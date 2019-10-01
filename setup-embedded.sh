#!/bin/bash
set -eux

sudo apt install openjdk-8-jre-headless

VERSION=1.16.0
DRILL_BASE_DIR=/var/lib/drill

mkdir -p $DRILL_BASE_DIR
chmod -R 777 $DRILL_BASE_DIR

cd $DRILL_BASE_DIR

wget "http://apache.mirrors.hoobly.com/drill/drill-"$VERSION/apache-drill-"$VERSION.tar.gz"""

DRILLDIR="apache-drill-$VERSION"
FULL_PATH=${DRILL_BASE_DIR}/${DRILLDIR}

tar -xzvf $DRILLDIR.tar.gz

mkdir -p $FULL_PATH/jars/3rdparty
cd $FULL_PATH/jars/3rdparty

wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.7/hadoop-azure-2.7.7.jar
wget http://central.maven.org/maven2/com/microsoft/azure/azure-storage/8.0.0/azure-storage-8.0.0.jar

cd $FULL_PATH/jars

wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.0.0-alpha3/hadoop-azure-datalake-3.0.0-alpha3.jar
wget http://central.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.1.5/azure-data-lake-store-sdk-2.1.5.jar

$DRILLDIR/bin/drillbit.sh restart

cd $FULL_PATH

STATUS=$(./bin/drillbit.sh status)
echo $STATUS
if [[ $STATUS != "drillbit is running." ]]; then
	>&2 echo "Drill installation failed"
	exit 1
fi
