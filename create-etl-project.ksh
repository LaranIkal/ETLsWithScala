#!/usr/bin/ksh

newLine=$'\n' # Doing this because ksh does not allow to concatenate the \n directly inside the string 

printf "\nThis script will create the etl project structure\n"
printf "\nBefore executing this script it is good to open it and\n"
printf "\nsee the sbt, scala and libraries versions\n"
printf "\nEnter Project Name:\n"

read projectname

echo $projectname

mkdir $projectname
cd $projectname
mkdir -p src/main/scala/libraries
mkdir project target
mkdir DataFiles
mkdir log

sbtbuild="name := \"$projectname\"$newLine"
sbtbuild="${sbtbuild}version := \"0.1\"$newLine"
sbtbuild="${sbtbuild}scalaVersion := \"3.3.1\"$newLine $newLine"

sbtbuild="${sbtbuild}These libraries versions will work but maybe they are not the last versions$newLine"
sbtbuild="${sbtbuild}Go to https://mvnrepository.com and check the last versions you want to work with$newLine $newLine"
sbtbuild="${sbtbuild}// https://mvnrepository.com/artifact/org.scalikejdbc/scalikejdbc$newLine"
sbtbuild="${sbtbuild}libraryDependencies += \"org.scalikejdbc\" %% \"scalikejdbc\" % \"4.1.0\"$newLine"

sbtbuild="${sbtbuild}// https://mvnrepository.com/artifact/ch.qos.logback/logback-classic$newLine"
sbtbuild="${sbtbuild}libraryDependencies += \"ch.qos.logback\" % \"logback-classic\" % \"1.4.11\"$newLine"

sbtbuild="${sbtbuild}// https://mvnrepository.com/artifact/net.sourceforge.csvjdbc/csvjdbc$newLine"
sbtbuild="${sbtbuild}libraryDependencies += \"net.sourceforge.csvjdbc\" % \"csvjdbc\" % \"1.0.41\"$newLine"

sbtbuild="${sbtbuild}// https://mvnrepository.com/artifact/org.xerial/sqlite-jdbc$newLine"
lsbtbuild="${sbtbuild}ibraryDependencies += \"org.xerial\" % \"sqlite-jdbc\" % \"3.44.1.0\"$newLine"

echo "$sbtbuild" > build.sbt

echo "sbt.version=1.9.6" > project/build.properties

ptemplate="import scalikejdbc.*$newLine"
ptemplate="${ptemplate}import libraries.* $newLine $newLine"
ptemplate="${ptemplate}//When needed parameters adjust the main as shown below$newLine"
ptemplate="${ptemplate}//@main def EtlSimple(etlParentName: String, etlChildName: String) = {$newLine"
ptemplate="${ptemplate}@main def EtlSimple = {$newLine"
ptemplate="${ptemplate}  hello() // Calling hello to avoid error when importing empty libraries directory$newLine}$newLine"

echo "$ptemplate"> src/main/scala/$projectname.scala

echo "package libraries $newLine ${newLine}class hello {$newLine  println(\"Hello new ETL.\")${newLine}}" > src/main/scala/libraries/hello.scala

# Create Database
etlDB=".open DataFiles/etl.sqlite.db$newLine"

# Create cross reference table.
# sqlite3 binary file should already be installed and added to the system path.

etlDB="$etlDB CREATE TABLE etl_xreftable (xreftype VARCHAR NOT NULL , from_value VARCHAR  , from_value1 VARCHAR  , to_value VARCHAR NOT NULL );$newLine"

etlDB="$etlDB CREATE INDEX etl_xreftable_idx1 ON etl_xreftable (xreftype ASC, from_value ASC, from_value1 ASC);$newLine"
etlDB="$etlDB CREATE INDEX etl_xreftable_idx2 ON etl_xreftable (xreftype ASC, to_value ASC);$newLine"
echo "$etlDB" | sqlite3 


