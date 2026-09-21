unit CH341DLL;

interface

const
  DLL_NAME = 'CH341DLL.DLL';

// USB device ID
CH341A_VENDOR_ID = $1A86;
CH341A_PRODUCT_ID = $5512;

// Command definitions
CH341_CMD_I2C_STREAM               = $A2;
CH341_CMD_I2C_STM_SET              = $60;
CH341_CMD_I2C_STM_END              = $75;
CH341_CMD_I2C_STM_STA              = $74;
CH341_CMD_I2C_STM_STO              = $75;
CH341_CMD_I2C_STM_OUT              = $A3;
CH341_CMD_I2C_STM_IN               = $A4;
CH341_CMD_I2C_STM_MAX              = $1F;
CH341_CMD_I2C_STM_MSUS             = $00;
CH341_CMD_I2C_STM_DELAY            = $E0;

CH341_CMD_SPI_STREAM               = $A8;
CH341_CMD_SPI_STM_STA              = $A8;
CH341_CMD_SPI_STM_STO              = $A9;
CH341_CMD_SPI_STM_OUT              = $AA;
CH341_CMD_SPI_STM_IN               = $AB;
CH341_CMD_SPI_STM_DLY              = $AC;

CH341_CMD_UIO_STREAM               = $AD;
CH341_CMD_UIO_STM_DIR              = $AE;
CH341_CMD_UIO_STM_DAT              = $AF;
CH341_CMD_UIO_STM_END              = $00;

// SPI chip select
CH341_SPI_CS_LOW                   = $A8;
CH341_SPI_CS_HIGH                  = $A9;

// GPIO directions
CH341_D0_OUT                       = $01;
CH341_D1_OUT                       = $02;
CH341_D2_OUT                       = $04;
CH341_D3_OUT                       = $08;
CH341_D4_OUT                       = $10;
CH341_D5_OUT                       = $20;
CH341_D6_OUT                       = $40;
CH341_D7_OUT                       = $80;

// Error codes
ERROR_SUCCESS                      = 0;
ERROR_INVALID_HANDLE               = 1;
ERROR_DEVICE_NOT_FOUND             = 2;
ERROR_OPEN_FAILED                  = 3;
ERROR_WRITE_FAILED                 = 4;
ERROR_READ_FAILED                  = 5;
ERROR_TIMEOUT                      = 6;

type
  TCH341OpenDevice = function: Integer; stdcall;
  TCH341CloseDevice = procedure(Index: Integer); stdcall;
  TCH341GetVersion = function: Byte; stdcall;
  
  // I2C functions
  TCH341SetStreamI2C = procedure(Index: Integer; Clock: Integer); stdcall;
  TCH341StreamI2C = function(Index: Integer; WriteLength: Integer; WriteBuffer: PByte; 
    ReadLength: Integer; ReadBuffer: PByte): Boolean; stdcall;
  TCH341SingleReadI2C = function(Index: Integer; ChipAddress: Byte; AddrRegister: Byte; 
    CurrentData: PByte): Boolean; stdcall;
  TCH341SingleWriteI2C = function(Index: Integer; ChipAddress: Byte; AddrRegister: Byte; 
    WriteData: Byte): Boolean; stdcall;
  TCH341ReadI2C = function(Index: Integer; ChipAddress: Byte; AddrRegister: Byte; 
    Length: Integer; Buffer: PByte): Boolean; stdcall;
  TCH341WriteI2C = function(Index: Integer; ChipAddress: Byte; AddrRegister: Byte; 
    Length: Integer; Buffer: PByte): Boolean; stdcall;
  
  // SPI functions
  TCH341SetStreamSPI = procedure(Index: Integer; Clock: Integer); stdcall;
  TCH341StreamSPI = function(Index: Integer; ChipSelect: Integer; WriteLength: Integer; 
    WriteBuffer: PByte; ReadLength: Integer; ReadBuffer: PByte): Boolean; stdcall;
  TCH341SingleReadSPI = function(Index: Integer; ChipSelect: Integer; AddrRegister: Byte; 
    CurrentData: PByte): Boolean; stdcall;
  TCH341SingleWriteSPI = function(Index: Integer; ChipSelect: Integer; AddrRegister: Byte; 
    WriteData: Byte): Boolean; stdcall;
  TCH341ReadSPI = function(Index: Integer; ChipSelect: Integer; AddrRegister: Byte; 
    Length: Integer; Buffer: PByte): Boolean; stdcall;
  TCH341WriteSPI = function(Index: Integer; ChipSelect: Integer; AddrRegister: Byte; 
    Length: Integer; Buffer: PByte): Boolean; stdcall;
  
  // GPIO/UIO functions
  TCH341SetOutput = function(Index: Integer; Mask: Byte; Data: Byte): Boolean; stdcall;
  TCH341SetDirection = function(Index: Integer; Mask: Byte; Data: Byte): Boolean; stdcall;
  TCH341GetStatus = function(Index: Integer; var Status: Byte): Boolean; stdcall;
  TCH341GetInput = function(Index: Integer; var Data: Byte): Boolean; stdcall;
  
  // EEPROM functions
  TCH341ReadEEPROM = function(Index: Integer; Address: Integer; Length: Integer; 
    Buffer: PByte): Boolean; stdcall;
  TCH341WriteEEPROM = function(Index: Integer; Address: Integer; Length: Integer; 
    Buffer: PByte): Boolean; stdcall;
  TCH341EraseEEPROM = function(Index: Integer): Boolean; stdcall;
  
  // Parallel interface
  TCH341SetDataOut = function(Index: Integer; Data: Byte): Boolean; stdcall;
  TCH341GetDataIn = function(Index: Integer; var Data: Byte): Boolean; stdcall;
  TCH341SetControl = function(Index: Integer; Control: Byte): Boolean; stdcall;
  TCH341GetControl = function(Index: Integer; var Control: Byte): Boolean; stdcall;

var
  CH341OpenDevice: TCH341OpenDevice;
  CH341CloseDevice: TCH341CloseDevice;
  CH341GetVersion: TCH341GetVersion;
  CH341SetStreamI2C: TCH341SetStreamI2C;
  CH341StreamI2C: TCH341StreamI2C;
  CH341SingleReadI2C: TCH341SingleReadI2C;
  CH341SingleWriteI2C: TCH341SingleWriteI2C;
  CH341ReadI2C: TCH341ReadI2C;
  CH341WriteI2C: TCH341WriteI2C;
  CH341SetStreamSPI: TCH341SetStreamSPI;
  CH341StreamSPI: TCH341StreamSPI;
  CH341SingleReadSPI: TCH341SingleReadSPI;
  CH341SingleWriteSPI: TCH341SingleWriteSPI;
  CH341ReadSPI: TCH341ReadSPI;
  CH341WriteSPI: TCH341WriteSPI;
  CH341SetOutput: TCH341SetOutput;
  CH341SetDirection: TCH341SetDirection;
  CH341GetStatus: TCH341GetStatus;
  CH341GetInput: TCH341GetInput;
  CH341ReadEEPROM: TCH341ReadEEPROM;
  CH341WriteEEPROM: TCH341WriteEEPROM;
  CH341EraseEEPROM: TCH341EraseEEPROM;
  CH341SetDataOut: TCH341SetDataOut;
  CH341GetDataIn: TCH341GetDataIn;
  CH341SetControl: TCH341SetControl;
  CH341GetControl: TCH341GetControl;

function LoadCH341DLL: Boolean;
procedure UnloadCH341DLL;
function IsDLLLoaded: Boolean;

implementation

uses
  Windows, SysUtils;

var
  DLLHandle: THandle = 0;

function LoadCH341DLL: Boolean;
begin
  Result := False;
  if DLLHandle <> 0 then
  begin
    Result := True;
    Exit;
  end;
  
  DLLHandle := LoadLibrary(DLL_NAME);
  if DLLHandle = 0 then
  begin
    RaiseLastOSError;
    Exit;
  end;
  
  @CH341OpenDevice := GetProcAddress(DLLHandle, 'CH341OpenDevice');
  @CH341CloseDevice := GetProcAddress(DLLHandle, 'CH341CloseDevice');
  @CH341GetVersion := GetProcAddress(DLLHandle, 'CH341GetVersion');
  @CH341SetStreamI2C := GetProcAddress(DLLHandle, 'CH341SetStreamI2C');
  @CH341StreamI2C := GetProcAddress(DLLHandle, 'CH341StreamI2C');
  @CH341SingleReadI2C := GetProcAddress(DLLHandle, 'CH341SingleReadI2C');
  @CH341SingleWriteI2C := GetProcAddress(DLLHandle, 'CH341SingleWriteI2C');
  @CH341ReadI2C := GetProcAddress(DLLHandle, 'CH341ReadI2C');
  @CH341WriteI2C := GetProcAddress(DLLHandle, 'CH341WriteI2C');
  @CH341SetStreamSPI := GetProcAddress(DLLHandle, 'CH341SetStreamSPI');
  @CH341StreamSPI := GetProcAddress(DLLHandle, 'CH341StreamSPI');
  @CH341SingleReadSPI := GetProcAddress(DLLHandle, 'CH341SingleReadSPI');
  @CH341SingleWriteSPI := GetProcAddress(DLLHandle, 'CH341SingleWriteSPI');
  @CH341ReadSPI := GetProcAddress(DLLHandle, 'CH341ReadSPI');
  @CH341WriteSPI := GetProcAddress(DLLHandle, 'CH341WriteSPI');
  @CH341SetOutput := GetProcAddress(DLLHandle, 'CH341SetOutput');
  @CH341SetDirection := GetProcAddress(DLLHandle, 'CH341SetDirection');
  @CH341GetStatus := GetProcAddress(DLLHandle, 'CH341GetStatus');
  @CH341GetInput := GetProcAddress(DLLHandle, 'CH341GetInput');
  @CH341ReadEEPROM := GetProcAddress(DLLHandle, 'CH341ReadEEPROM');
  @CH341WriteEEPROM := GetProcAddress(DLLHandle, 'CH341WriteEEPROM');
  @CH341EraseEEPROM := GetProcAddress(DLLHandle, 'CH341EraseEEPROM');
  @CH341SetDataOut := GetProcAddress(DLLHandle, 'CH341SetDataOut');
  @CH341GetDataIn := GetProcAddress(DLLHandle, 'CH341GetDataIn');
  @CH341SetControl := GetProcAddress(DLLHandle, 'CH341SetControl');
  @CH341GetControl := GetProcAddress(DLLHandle, 'CH341GetControl');
  
  Result := Assigned(@CH341OpenDevice) and Assigned(@CH341CloseDevice);
end;

procedure UnloadCH341DLL;
begin
  if DLLHandle <> 0 then
  begin
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
    
    @CH341OpenDevice := nil;
    @CH341CloseDevice := nil;
    @CH341GetVersion := nil;
    @CH341SetStreamI2C := nil;
    @CH341StreamI2C := nil;
    @CH341SingleReadI2C := nil;
    @CH341SingleWriteI2C := nil;
    @CH341ReadI2C := nil;
    @CH341WriteI2C := nil;
    @CH341SetStreamSPI := nil;
    @CH341StreamSPI := nil;
    @CH341SingleReadSPI := nil;
    @CH341SingleWriteSPI := nil;
    @CH341ReadSPI := nil;
    @CH341WriteSPI := nil;
    @CH341SetOutput := nil;
    @CH341SetDirection := nil;
    @CH341GetStatus := nil;
    @CH341GetInput := nil;
    @CH341ReadEEPROM := nil;
    @CH341WriteEEPROM := nil;
    @CH341EraseEEPROM := nil;
    @CH341SetDataOut := nil;
    @CH341GetDataIn := nil;
    @CH341SetControl := nil;
    @CH341GetControl := nil;
  end;
end;

function IsDLLLoaded: Boolean;
begin
  Result := (DLLHandle <> 0) and Assigned(@CH341OpenDevice);
end;

initialization
finalization
  UnloadCH341DLL;
end.
