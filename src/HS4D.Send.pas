unit HS4D.Send;

interface

uses
  RESTRequest4D,
  HS4D.Interfaces,
  System.Classes,
  Vcl.ExtCtrls;

type
  THS4DSend = class(TInterfacedObject, iHS4DSend)
    private
      FParent : iHS4D;
      FFileName : String;
      FContentType : String;
      FFileStream : TBytesStream;
      FEndPoint : string;
      FContent : string;
      FPath : string;
    public
      constructor Create(Parent : iHS4D);
      destructor Destroy; override;
      class function New (aParent : iHS4D): iHS4DSend;
      function Send : iHS4DSend;

      function FileName( aValue : String ) : iHS4DSend;
      function ContentType( aValue : String ) : iHS4DSend;
      function EndPoint(aValue : string) : iHS4DSend;
      function Path(aValue : string) : iHS4DSend;
      function FileStream( aValue : TBytesStream ) : iHS4DSend; overload;
      function FileStream( aValue : TImage ) : iHS4DSend; overload;
      function ToString : string;
  end;

implementation

{ THS4DSend }

function THS4DSend.ContentType(aValue: String): iHS4DSend;
begin
  Result:= Self;
  FContentType:= aValue;
end;

constructor THS4DSend.Create(Parent : iHS4D);
begin
  FParent:= Parent;
end;

destructor THS4DSend.Destroy;
begin

  inherited;
end;

function THS4DSend.EndPoint(aValue: string): iHS4DSend;
begin
  result:= self;
  FEndPoint:= aValue;
end;

function THS4DSend.FileName(aValue: String): iHS4DSend;
begin
  Result:= Self;
  FFileName:= aValue;
end;

function THS4DSend.FileStream(aValue: TBytesStream): iHS4DSend;
begin
  Result := Self;
  FFileStream := aValue;
end;

function THS4DSend.FileStream(aValue: TImage): iHS4DSend;
begin
  Result := Self;
  if not Assigned(FFileStream) then
    FFileStream := TBytesStream.Create();
  {$IFDEF HAS_FMX}
    aValue.Bitmap.SaveToStream(FFileStream);
  {$ELSE}
    aValue.Picture.SaveToStream(FFileStream);
  {$ENDIF}
end;

class function THS4DSend.New(aParent : iHS4D): iHS4DSend;
begin
  Result:= Self.Create(aParent);
end;

function THS4DSend.Path(aValue: string): iHS4DSend;
begin
  Result:= Self;
  FPath:= aValue;
end;

function THS4DSend.Send : iHS4DSend;
var
  LResponse: IResponse;
  lHost : string;
begin
  Result:= Self;

  lHost:= copy(FParent.Credential.BaseURL,(pos('//',FParent.Credential.BaseURL)+2), length(FParent.Credential.BaseURL));
  lHost:= copy(lHost,0,(pos(':',lHost)-1));

  LResponse :=
  TRequest.New.BaseURL(FParent.Credential.BaseURL+FEndPoint)
    .ContentType(FContentType)
    .AddHeader('FileName', FFileName)
    .AddHeader('Path', FPath)
    .AddHeader('Host', lHost)
    .Accept('*/*')
    .AddBody(FFileStream)
    .Post;

  if LResponse.StatusCode = 201 then
     FContent:= FParent.Credential.BaseURL + LResponse.Content;
end;

function THS4DSend.ToString: string;
begin
  Result:= FContent;
end;

end.

