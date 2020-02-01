unit pasconfigtestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  TTestCase = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestCase.TestHookUp;
begin
  Fail('Напишите ваш тест');
end;

procedure TTestCase.SetUp;
begin

end;

procedure TTestCase.TearDown;
begin

end;

initialization

  RegisterTest(TTestCase);
end.

