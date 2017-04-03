;~ Get damlevels.pdf from coct website: http://resource.capetown.gov.za/documentcentre/Documents/City%20research%20reports%20and%20review/damlevels.pdf

#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Crypt.au3>
#include <Date.au3>

Local $SaveFolder = "D:\DamLevelsCT\Latest\"
Local $URL = "http://resource.capetown.gov.za/documentcentre/Documents/City%20research%20reports%20and%20review/damlevels.pdf"
Local $FileName = "damlevels.pdf"
Local Const $Hashfile = $SaveFolder & "latestHash"
Local $sFilePath = $SaveFolder & $FileName
Local $FinalFolder = "D:\DamLevelsCT\"

Local $hFileOpen = FileOpen($Hashfile, $FO_READ)
Local $sFileRead = FileRead($hFileOpen)
If $hFileOpen = -1 Then $sFileRead = ""
Local $CurrentDate = _DateTimeFormat(_NowCalc(), 2)
Local $SHA1 = DownloadFile($URL, $SaveFolder, $FileName)

If $SHA1 = $sFileRead Then 
  FileDelete($sFilePath)
  MemoWrite("Deleted File cause same hash")
  Exit
EndIf

WriteHashFile($Hashfile, $SHA1)
FileMove($sFilePath, $FinalFolder & "DamLevelsCT" & $CurrentDate & ".pdf", 1)

Func WriteHashFile($Hashfile, $Hash)
  FileDelete($Hashfile)
  Sleep(100)
  If Not FileWrite($Hashfile, $Hash) Then
    Return False
  EndIf
EndFunc

Func DownloadFile($URL, $SaveFolder, $FileName)
    _Crypt_Startup()
    ; Save the downloaded file to the temporary folder.
    Local $sFilePath = $SaveFolder & $FileName
    Local $hDownload = InetGet($URL, $sFilePath, $INET_FORCERELOAD)
      
    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    If StringStripWS($sFilePath, $STR_STRIPALL) <> "" And FileExists($sFilePath) Then ; Check there is a file available to find the hash digest
      $Crypt = _Crypt_HashFile($sFilePath, $CALG_SHA1) ; Create a hash of the file.
      If @error Then 
        FileDelete($Hashfile)
        _Crypt_Shutdown()
        Exit
      Endif
    EndIf
   
    _Crypt_Shutdown()

    Return $Crypt
EndFunc   ;==>DownloadDamLevels

Func MemoWrite($sMessage)
    ConsoleWrite($sMessage & @CRLF)
EndFunc ;==>MemoWrite