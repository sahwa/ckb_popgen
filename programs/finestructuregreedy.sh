#!/bin/bash
## A script to perform greedy maximisation using finestructure
function usage {
   printf "Usage: %s: [-r] [-R] [-d] [-m value] [-x value] [-t value] [-a value] [-f value] datafile outputfile\n" $0
   echo "Essentials: datafile and outputfile"
   echo "Important flags are -m and -x"
   echo "  -m value: sets the number of repeated FineSTRUCTURE runs to perform before giving in. (default: 20)"
   echo "  -x value: sets the number of FineSTRUCTURE iterations to perform per step (finestructure -x flag). (default: 20000)"
   echo "  -t value: (finestructure -t flag). (default: t=100000000, i.e. effectively infinite. careful, this may be slow)"
   echo "  -a value: finestructure flags to be passed to all runs, e.g. \"-X -Y\". Quotes essential! Usually not needed. (default: \"\")"
   echo "  -f value: set the location of the finestructure executable (default: finestructure)"
   echo "  -r: when set, temporary files are replaced. without this you can run more iterations by changing -m and -x"
   echo "  -R: when set, the final tree file is deleted if present. Default is to not run."
   echo "  -d: perform a dry run but don't actually do anything. Useful to see the fineSTRUCTURE arguments sued in each step."
   echo "EXAMPLE: $0 -a \"-X -Y\ -c 0.2\" -m 4 -t 1000 -x 50000 test.chunkcounts.out testgreedy.xml"
   echo ".. continued with: $0 -a \"-X -Y\ -c 0.2\" -m 10 -R -t 1000 -x 50000 test.chunkcounts.out testgreedy.xml"
   echo ""
   echo "FineSTRUCTURE is in theory run until convergence; i.e. until successive greedy tree runs have the same tree."
   echo "You must therefore set \"-x\" large enough to find differences at each step."
   echo "With \"-x\" too small, early stopping is likely and a lower K will be found."
   echo "The tree is computed only once, at the end; intermediate trees are present but highly stochastic." 
   echo "Set \"-t\" to some smaller value if you are worried you may find very many populations; you can always rerun the final step."
   echo ""
   echo "You may ignore the two warnings:"
   echo "WARNING!  NOT TESTING ALL <c> COMBINATIONS! (max 1)"
   echo "WARNING! Cannot confirm data file is the same as the MCMC was run on!"
   echo "The first is generated by each iteration, the second by all but the initial run."
   exit 2
}

## Some default parameters
m=20 # number of repeated FS runs to perform
x=10000 # number of steps between checking for a change in K
t=100000000 # effectively infinite number of tree steps
additionalcmds="" # add anything needed by all FS runs, e.g. "-X -Y
finestructure="/well/ckb/users/aey472/program_files/finestructure4/fs fs" # the location of the finestructure command (here, msut be in your path)

remove=0 # whether we remove the old temporary files or not (0 = not)
removetree=0 # whether we remove the old tree or not (0 = not)
dryrun=0 # whether we do a "dry run", i.e. do no actual finestructure runs

############################################
## Function definitions
function is_integer() {
    printf "%d" $1 > /dev/null 2>&1
    return $?
}
function validate {
    if  ! is_integer $m ; then
	echo "Invalid -m option : must provide a number!"
	usage
    fi
    if  ! is_integer $x ; then
	echo "Invalid -x option : must provide a number!"
	usage
    fi
    if  ! is_integer $t ; then
	echo "Invalid -t option : must provide a number!"
	usage
    fi
}

runon=1 # current run
finished=0 # flag for whether we have finished yet

while getopts dhrRm:x:t:a:f: name
do
    case $name in
	a) additionalcmds="$OPTARG";;
        m) m="$OPTARG";;
        x) x="$OPTARG";;
	t) t="$OPTARG";;
	f) finestructure="$OPTARG";;
	r) remove=1;;
	R) removetree=1;;
	d) dryrun=1;;
	h) usage;;
        ?) usage;;
    esac
done
shift $(($OPTIND - 1))
datafile="$1" # the datafile to process REQUIRED
outfile="$2" # the final output file REQUIRED


##############################################
## Validate the command line options, and construct intermediate variable names
validate

command -v $finestructure >/dev/null 2>&1 || {  # check for finestructure
    echo "ERROR: finestructure (\"$finestructure\") cannot be executed. Is it in your path? If not, specify its path with -f"
    usage
}

if [ ! -s $datafile ] ;then # check for datafile
    echo "ERROR: datafile is not present or is empty"
    usage
fi

tmp=`echo $outfile | grep ".xml" | wc -l` # check for outfile having correct ending
if [ $tmp -eq 0 ] ; then
    echo "ERROR: Require .xml file name ending for outfile (\"$outfile\" is invalid)"
    usage
fi

if [ $removetree -eq 0 -a -e $outfile ] ; then # check for outfile existing if required
    echo "ERROR: File $outfile exists and will not be overwritten. Rerun with \"-R\" flag to overwrite."
    usage
fi

## Derived files
initial=`echo $outfile | sed s/.xml/.estep0.xml/` # an initial file (temporary)
iterroot=`echo $outfile | sed s/.xml/.estep/` # the temporary files for each iteration of the maximisation

echo "Processing datafile $datafile :"
echo "  Initial file $initial"
echo "  Maximisation Iterations: ${iterroot}1-${m}.xml"
echo "  outfile $outfile"

##############################################
## The initial run and first iteration
if [ ! -f $initial -o $remove -eq 1 ] ; then
    echo "** Creating Initial state"
    cmd="$finestructure $additionalcmds -I 1 -x 0 -y 0 $datafile $initial"
    echo "$cmd"
    if [ $dryrun -eq 0 ] ; then $cmd ; fi
else
    echo ".. Using pre-existing initial state"
fi
if [ ! -f $iterroot${runon}.xml  -o  $remove -eq 1 ] ; then
    echo "** Iteration $runon"
    cmd="$finestructure $additionalcmds -m T -x $x -t 1 $datafile $initial $iterroot${runon}.xml"
    echo "$cmd"
    if [ $dryrun -eq 0 ] ; then $cmd ; fi
else
    echo ".. Using pre-existing $iterroot${runon}.xml"
fi

##############################################
## main maximisation loop
while [ $finished -ne 1 ] ; do
    lastfile="$iterroot${runon}.xml"
    runon=$(($runon + 1))
    echo "** Iteration $runon"
    thisfile="$iterroot${runon}.xml"
    if [ ! -f $thisfile -o  $remove -eq 1 ] ; then # check for whether file exists
	cmd="$finestructure $additionalcmds  -m T -x $x -t 1 $datafile $lastfile $thisfile"
	echo "$cmd"
	if [ $dryrun -eq 0 ] ; then $cmd ; fi
    else
	echo ".. Using pre-existing $thisfile"
    fi
    if [ $runon -ge $m ] ; then
	echo ".. Terminating with incomplete maximisation run after $runon iterations"
	finished=1
    fi
    if [ $dryrun -eq 1 ]; then
	echo ".. Terminating due to dry run"
	finished=1
    else
	lastkline=`grep "<K>" $lastfile` # we detect convergence only using K due to issues with ordering
	thiskline=`grep "<K>" $thisfile`
	if [ "$lastkline" == "$thiskline" ] ; then
	    echo ".. Approximate Convergence after $runon iterations"
	    finished=1
	else
	    echo ".. Last $lastkline, this $thiskline, continuing"
	    echo ".. Run $runon Finished $finished"
	fi
    fi
done

##############################################
## Finally, construct the tree
echo "** Building tree"
cmd="$finestructure $additionalcmds  -m T -T 1 -t $t $datafile $thisfile $outfile"
echo "$cmd"
if [ $dryrun -eq 0 ] ; then $cmd ; fi
