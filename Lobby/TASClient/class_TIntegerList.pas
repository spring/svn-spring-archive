{ Nom        : TIntegerList
Fonction     : Classe de list pour valeur Integer
Auteur       : Khemi
Date         : 18 mars 2003

Modification : Add getnext modif first -> Getfirst
Date         : 31 mars 2003
Par          : Khemi
}

unit class_TIntegerList;

interface
uses
  Sysutils,classes;
  
type
  TIntegerList =class(TList)
  
  {méthodes}
  Protected
  Fposition:Integer;             //position du item courant
  function GetItem(Index: Integer): Integer;
  procedure PutItem(Index: Integer; Item: Integer);
  
  Public
  constructor Create;
  destructor  Destroy; override;
  
  procedure Add(Item : Integer);              // ajout 1 item a la fin
  procedure Clear;  override;                 // efface tout
  procedure Delete(Index: Integer);           // efface 1 item position definie
  procedure Insert(Index: Integer; Item : Integer); //ajout 1 item position definie
  function  Remove(Item : Integer): Integer;       //supprime 1 item position definie
  function  GetLast(var sample : Integer): Boolean;  //retourne le dernier
  function  IndexOf(Item: Integer): Integer;           //retourne l'index de la premiere occurence
  function  GetFirst(var sample : Integer):Boolean;   // retourne le premier
  function  GetNext(var sample : Integer; var index : Integer):Boolean;   // retourne le suivant
  
  {propriétés}
  property Items[Index: Integer]: Integer read GetItem write PutItem; // default;
  
end;

implementation


//------------------------------------------------------------------------------
//constructeur
constructor TIntegerList.Create();
begin
  try
    inherited Create;
    Fposition:=-1;
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//retourne l'index de la premiere occurence
function TIntegerList.IndexOf(Item: Integer): Integer;
var
  ptr : ^Integer;
  cpt : Integer;
  
begin
  try
    if Self.Count = 0 then
    begin
      IndexOf := -1;
      Exit;
    end;
    cpt:=0;
    ptr:=  inherited Items[cpt];
    while (Item<>ptr^) AND (cpt<Count-1) do
    begin
      Inc(cpt);
      ptr:=  inherited Items[cpt];
    end;
    if (Item=ptr^) then
      IndexOf:=cpt
    else
      IndexOf:=-1;
  except
    IndexOf:=-1;
    raise;
  end;
  
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//recupere la valeur a un index spécifié
function TIntegerList.GetItem(Index: Integer): Integer;
var
  ptr : ^Integer;
  
begin
  try
    ptr:= inherited Items[Index];
    GetItem:=ptr^;
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//met une valeur a l'index spécifié
procedure TIntegerList.PutItem(Index: Integer; Item: Integer);
var
  ptr : ^Integer;
  
begin
  try
    ptr:= inherited Items[Index];
    ptr^:=  Item;
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//efface tous les élements de la liste
procedure TIntegerList.Clear;
var
  cpt  : Integer;
  ptr  : ^Integer;
  
begin
  try
    for cpt:=0  to Count-1 do
    begin
      ptr:= inherited Items[cpt];
      if (ptr<>nil) then Dispose(ptr);
    end;
    inherited Clear;
  except
    raise;
  end;
  
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//supprime la 1ere occurance dans le tableau renvoye 'lindex de l'element sup
function TIntegerList.Remove(Item : Integer): Integer;
var
  cpt : Integer;
  
begin
  try
    cpt:=IndexOf(Item);
    Delete(cpt);
    Remove:=cpt;
  except
    Remove:=-1;
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//retourne le premier élément du tableau
function TIntegerList.GetFirst(var sample : Integer): Boolean;
var
  ptr : ^Integer;
  
begin
  try
    
    ptr:= inherited Items[0];
    sample:=ptr^;
    GetFirst:=True;
    Fposition:=1;
  except
    GetFirst:=False;
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//retourne le prochain élément
function  TIntegerList.GetNext(var sample : Integer; var index : Integer):Boolean;
var
  ptr : ^Integer;
  
begin
  try
    ptr:= inherited Items[Fposition];
    sample:=ptr^;
    index:=Fposition;
    GetNext:=True;
    Inc(Fposition);
  except
    GetNext:=False;
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//retourne la valeur du dernier
function TIntegerList.GetLast(var sample: Integer):Boolean;
var
  ptr : ^Integer;
  
begin
  try
    ptr:= inherited Items[Count-1];
    sample:=ptr^;
    GetLast:=True;
  except
    GetLast:=False;
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ajoute un element dans la liste a la fin
procedure TIntegerList.Add(Item : Integer);
var
  ptr : ^Integer;
  
begin
  try
    New(ptr);
    ptr^:= Item;
    inherited Add(ptr);
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//supprime un élément a un endroit précis
procedure TIntegerList.Delete(Index: Integer);
var
  ptr : ^Integer;
  
begin
  try
    ptr:= inherited Items[Index];
    dispose(ptr);
    inherited Delete(Index);
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ajoute un element à un endroit precis
procedure TIntegerList.Insert(Index: Integer; Item: Integer);
var
  ptr : ^Integer;
  
begin
  try
    New(ptr);
    ptr^:= Item;
    inherited Insert(Index,ptr);
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//destructeur de l'instance
destructor TIntegerList.Destroy;
begin
  try
    Clear;
    inherited Destroy;
  except
    raise;
  end;
end;
//------------------------------------------------------------------------------


end.
