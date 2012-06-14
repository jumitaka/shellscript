#!/bin/ksh

####管理対象ログファイル設定項目 Start
mainDirectory="$HOME/app/oracle/diag/rdbms/eldis/eldis/trace"
fileName='alert_eldis.log'
generationDirStart=1
generationDirEnd=5
generationDirShift=1
dirHeader='alert'
dirNumDigit=2
suplessChar='0'
####管理対象ログファイル設定項目 End

function mainProc {
	cd $mainDirectory
	echo "Direcotry $mainDirectory"
	if [[ ! -a $fileName ]]; then
		echo "NoFile $fileName"
		exit 0
	fi
	fileCopyDirectories
	fileCopyDir $fileName $(makeSaveDirName $generationDirStart)
	fileUpdateEmpty $fileName	
}

function fileCopyDirectories {
	let n=$generationDirEnd
	while(( $n > $generationDirStart ))
	do
		fromDirName=$(makeSaveDirName $(($n-$generationDirShift)))
		toDirName=$(makeSaveDirName $n)
		fileInDirCopyDir "$fromDirName" "$toDirName"
		let n=$n-$generationDirShift
	done
}

function fileInDirCopyDir {
	if [[ ! -d $1 ]]; then
		mkdir $1
	fi
	fileCopyDir $1/$fileName $2
}

function fileCopyDir {
	if [[ ! -d $2 ]]; then
		mkdir $2
	fi
	if [[ -a $1 ]]; then
		cp -fp $1 $2
		echo $1' > '$2
	fi
}

function fileUpdateEmpty {
	if [[ -a $1 ]]; then
		: > $1
		echo $1' Clear'
	fi
}

function makeSaveDirName {
	# 戻り値
	echo "$dirHeader$(suplessStr $1 $dirNumDigit)"
}

# 文字サプレス
function suplessStr {
	val=$1
	while (( $2 > ${#val} ))
	do
		val=$suplessChar$val
	done
	# 戻り値
	echo "$val"
}

#main実行
mainProc