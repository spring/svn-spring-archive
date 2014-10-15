//*****************************************************************//
//                                                                 //
//  TBitList Object                                                //
//  Copyright© BrandsPatch LLC                                     //
//  http://www.explainth.at                                        //
//                                                                 //
//  All Rights Reserved                                            //
//                                                                 //
//  Permission is granted to use, modify and redistribute          //
//  the code in this Delphi unit on the condition that this        //
//  notice is retained unchanged.                                  //
//                                                                 //
//  BrandsPatch declines all responsibility for any losses,        //
//  direct or indirect, that may arise  as a result of using       //
//  this code.                                                     //
//                                                                 //
//                                                                 //
//*****************************************************************//
unit BitList;

interface

uses Windows,SysUtils,Classes;

type TByteList = array[0..8191] of Byte;
     PByteList = ^TByteList;
{This allows for a maximum of 8192*4 = 32768 boolean values to be stored.
 Increase if required}

type TBitList = class(TObject)
private
  FBytes:PByteList;
  //pointer to memory block used to store booleas
  FSize:Word;
  //size of the memory block, in bytes
  FPosition:Word;
  //position of the next bit boolean to be written
  FMaxPos:Integer;
  //maximum value for FPosition. e.g. if FSize is 4, FMaxPos would be 31
  function GetBits(Index:Integer):Boolean;
  procedure SetBits(Index:Integer;Value:Boolean);
  //an EBitList exception is triggered if Index is bad
  procedure Expand;
  //expands the memory block, 4 bytes at a time
public
  constructor CreateEx;
  //create a new instance
  constructor CreateFromStream(AStream:TStream);
  //recreate from streamed data
  destructor Destroy;override;
  procedure WriteToStream(AStream:TStream);
  //write bit booleans to a stream
  procedure WriteDataToStream(AStream:TStream);
  procedure AddBit(Value:Boolean);
  //add a fresh bitbool. Memory block is expanded if necessary
  function FetchBit:Boolean;
  {Returns the bitbool at FPosition and then increments
   FPosition. Typically, you would use this to sequentially
   access bitbools after recreating them from streamed data
   in the context of other work where you need to make
   decisions based on a large number of streamed boolean values}
  procedure ReSet;
  //discards the memory block and resets it to store 32 bits
  property Bits[Index:Integer]:Boolean read GetBits write SetBits;default;
  property Position:Word read FPosition;
  property Size:Word read FSize;
end;

type EBitList = class(Exception);
//exception raised should things go wrong

implementation

constructor TBitList.CreateEx;
begin
  inherited Create;
  FSize:=4;FMaxPos:=31;
  FBytes:=AllocMem(FSize);//32 bits @ 8 bits per byte
end;

constructor TBitList.CreateFromStream(AStream:TStream);
begin
  with AStream do
  begin
    ReadBuffer(FSize,sizeof(FSize));
    FBytes:=AllocMem(FSize);
    ReadBuffer(FBytes^,FSize);
  end;
  FMaxPos:=(FSize shl 2) - 1;
  {As things stand this allows for a MAXWORD sized memory
   block. Change to FSize:Integer if you need more}
end;

destructor TBitList.Destroy;
begin
  ReAllocMem(FBytes,0);//remember to discard the memory block!
  inherited;
end;

procedure TBitList.WriteToStream(AStream:TStream);
var ASize:Word;
begin
  ASize:=(FPosition div 8) + ord(FPosition mod 8 > 0);
  with AStream do
  begin
    WriteBuffer(ASize,sizeof(ASize));
    WriteBuffer(FBytes^,ASize);
  end;
  {When streaming out we only take the first FPosition bits
   that have actually be written. The current memory block
   may be upto 31 bits larger}
end;

procedure TBitList.WriteDataToStream(AStream:TStream);
var ASize:Word;
begin
  ASize:=(FPosition div 8) + ord(FPosition mod 8 > 0);
  with AStream do
  begin
    WriteBuffer(FBytes^,ASize);
  end;
  {When streaming out we only take the first FPosition bits
   that have actually be written. The current memory block
   may be upto 31 bits larger}
end;

function TBitList.GetBits(Index:Integer):Boolean;
var AByte,ABit:Integer;
begin
  if (Index < 0) or (Index > FMaxPos) then raise EBitList.Create('Bad Index');
  AByte:=Index div 8;
  //which byte can the bitbool at position Index be found?
  ABit:=Index mod 8;
  //which bit of this byte holds that bitbool value?
  Result:=(FBytes^[AByte] and (1 shl ABit) > 0);
  //remember, FBytes is a pointer to an array
end;

procedure TBitList.SetBits(Index:Integer;Value:Boolean);
var AByte,ABit:Integer;
begin
  if (Index < 0) or (Index > FMaxPos) then raise EBitList.Create('Bad Index');
  AByte:=Index div 8;
  //which byte can the bitbool at position Index be found?
  ABit:=Index mod 8;
  //which bit of this byte holds that bitbool value?
  FBytes^[AByte]:=(FBytes^[AByte] and ($FF xor (1 shl ABit))) or (ord(Value) shl ABit);
  {In the appropriate byte, AByte, we first turn OFF the bit at
   position ABit - corresponds to the Index'th bitbool - and then
   turn it on again if Value is TRUE}
end;

procedure TBitList.AddBit(Value:Boolean);
var AByte,ABit:Integer;
begin
  if (FPosition = FMaxPos) then Expand;
  AByte:=FPosition div 8;
  ABit:=FPosition mod 8;
  FBytes^[AByte]:=(FBytes^[AByte] and ($FF xor (1 shl ABit))) or (ord(Value) shl ABit);
  inc(FPosition);
  {First We expand the memory block if necessary.
   Then we establish the byte to modify and the bit in that bit
   Then modify as in SetBits
   Finally, increment FPosition.
   Use this method to sequentially add bitbools starting from
   FPosition = 0
  }
end;

procedure TBitList.Expand;
begin
  inc(FSize,4);//room for another 32 bits
  ReAllocMem(FBytes,FSize);
  FBytes[FSize-1] := 0;
  FBytes[FSize-2] := 0;
  FBytes[FSize-3] := 0;
  FBytes[FSize-4] := 0;
  FMaxPos:=(FSize shl 2) - 1;
end;

function TBitList.FetchBit:Boolean;
var AByte,ABit:Integer;
begin
  AByte:=FPosition div 8;
  ABit:=FPosition mod 8;
  Result:=(FBytes^[AByte] and (1 shl ABit) > 0);
  inc(FPosition);
  {Use this method to sequentially retrieve bits starting
   from FPosition = 0. Typically, this will be after you
   recreate the bitbools from streamed data.

   This method can be improved - instead of recalculating
   AByte and ABit each time you could do this

   1. Private FByte and FBit fields replace AByte and ABit
   2. Both start off at zero.
   3. At the end of each call to FetchBit you do this

   FBit:=(FBit + 1)*ord(FBit < 8);
   //this changes FBit from 0 to 7 and then resets it to 0
   FByte:=FByte + ord(FBit = 0);
   //moves to a fresh byte if FBit has just been reset

   The benefits are debatable - you are simply replacing one kind
   of math with another. An option would be to simply replace
   the local AByte and ABit variables with object fields FByte
   and FBit and do the same calculations as above.

   You could put in a test here to block attempts to fetch
   non-existant bits. For example

   if (FPosition > FMaxPos) then raise EBitList.Create(''). If you
   are sure that this will never occur best leave out this test since
   it slows things down}
end;

procedure TBitList.ReSet;
begin
  FSize:=4;
  FPosition:=0;
  FMaxPos:=31;
  ReAllocMem(FBytes,4);
  FillChar(FBytes^,4,0);
end;

end.
