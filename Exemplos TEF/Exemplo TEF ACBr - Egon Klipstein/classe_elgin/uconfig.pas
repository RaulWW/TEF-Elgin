unit uconfig;

interface

uses
  AcbrPosPrinter,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ComCtrls;

type
  Tfrmconfig = class(TForm)
    pntitulo: TPanel;
    pnrodape: TPanel;
    btsalvar: TSpeedButton;
    btcancelar: TSpeedButton;
    pgc: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    edtporta_impressora_ESC_POS: TMaskEdit;
    Label53: TLabel;
    btbuscaportawindows: TSpeedButton;
    Label51: TLabel;
    cbimpressora_ESC_POS: TComboBox;
    Label52: TLabel;
    edtavanco: TMaskEdit;
    cblistaimpressoras: TComboBox;
    Label309: TLabel;
    cbELGIN_impressao_cliente: TComboBox;
    Label310: TLabel;
    cbELGIN_impressao_loja: TComboBox;
    cbcomprovantetefreduzido: TCheckBox;
    cbcomprovanteteflojasimplificado: TCheckBox;
    cbELGIN_SalvarLOG: TCheckBox;
    Image3: TImage;
    SpeedButton1: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure btcancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btbuscaportawindowsClick(Sender: TObject);
    procedure cblistaimpressorasEnter(Sender: TObject);
    procedure cblistaimpressorasSelect(Sender: TObject);
    procedure cblistaimpressorasExit(Sender: TObject);
    procedure btsalvarClick(Sender: TObject);
    procedure edtcompanhiaPayerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmconfig: Tfrmconfig;

implementation

{$R *.dfm}

uses udm, uprinc;

procedure Tfrmconfig.btbuscaportawindowsClick(Sender: TObject);
var
   impressora : TACBrPosPrinter;
   lista      : TStringList;
begin
   impressora := TACBrPosPrinter.Create(nil);
   lista := TStringList.Create;
   impressora.Device.AcharPortasSeriais( lista );
   impressora.Device.AcharPortasUSB( lista );
   impressora.Device.AcharPortasRAW( lista );
   impressora.Device.AcharPortasBlueTooth( lista );
   cblistaimpressoras.Items := lista;
   lista.Free;
   impressora.Free;
   //---------------------------------------------------------------------------
   cblistaimpressoras.Visible := true;
   cblistaimpressoras.Left    := edtporta_impressora_ESC_POS.Left;
   cblistaimpressoras.Top     := edtporta_impressora_ESC_POS.Top;
   cblistaimpressoras.Width   := edtporta_impressora_ESC_POS.Width;
   cblistaimpressoras.SetFocus;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.btcancelarClick(Sender: TObject);
begin
   frmconfig.Close;
end;

procedure Tfrmconfig.btsalvarClick(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   dm.tblconf.EmptyDataSet;
   dm.tblconf.append;
   //---------------------------------------------------------------------------
   dm.tblconf.FieldByName('ELGIN_ComprovanteCliente').AsInteger      := cbELGIN_impressao_cliente.ItemIndex;
   dm.tblconf.FieldByName('ELGIN_ComprovanteLoja').AsInteger         := cbELGIN_impressao_loja.ItemIndex;
   dm.tblconf.FieldByName('ELGIN_SalvarLOG').AsBoolean               := cbELGIN_SalvarLOG.Checked;
   dm.tblconf.FieldByName('ELGIN_ImpressaoReduzida').AsBoolean       := cbcomprovantetefreduzido.Checked;
   dm.tblconf.FieldByName('ELGIN_ComprovanteSimplificado').AsBoolean := cbcomprovanteteflojasimplificado.Checked;
   //---------------------------------------------------------------------------
   dm.tblconf.FieldByName('IMPRESSORAPortaNome').AsString          := edtporta_impressora_ESC_POS.Text;
   dm.tblconf.FieldByName('IMPRESSORAModelo').AsInteger            := cbimpressora_ESC_POS.ItemIndex;  // Padr�o EPSON
   dm.tblconf.FieldByName('IMPRESSORAAvanco').AsInteger            := strtointdef(edtavanco.Text,5);  //  Padr�o 5 linhas
   //---------------------------------------------------------------------------
   dm.tblconf.Post;
   dm.tblconf.SaveToFile('config.xml');
   //---------------------------------------------------------------------
   btcancelar.Click;
end;

procedure Tfrmconfig.cblistaimpressorasEnter(Sender: TObject);
begin
   cblistaimpressoras.DroppedDown := true;
end;

procedure Tfrmconfig.cblistaimpressorasExit(Sender: TObject);
begin
   cblistaimpressoras.Visible := false;
end;

procedure Tfrmconfig.cblistaimpressorasSelect(Sender: TObject);
begin
   if cblistaimpressoras.ItemIndex>=0 then
      edtporta_impressora_ESC_POS.Text := cblistaimpressoras.Items[cblistaimpressoras.ItemIndex];
   edtporta_impressora_ESC_POS.SetFocus;
end;

procedure Tfrmconfig.edtcompanhiaPayerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_escape : btcancelar.Click;
      vk_return : perform(40,0,0);
   end;
end;

procedure Tfrmconfig.FormActivate(Sender: TObject);
begin
   //---------------------------------------------------------------------------
   pntitulo.Align := alTop;
   pnrodape.Align := alBottom;
   //---------------------------------------------------------------------------
   pgc.Align := alClient;
   //---------------------------------------------------------------------------
   //  Carregar as configura��es do DataSet para os componentes visuais e interativos
   //---------------------------------------------------------------------------
   // Dados do TEF
   cbELGIN_impressao_cliente.ItemIndex      := dm.tblconf.FieldByName('ELGIN_ComprovanteCliente').AsInteger;
   cbELGIN_impressao_loja.ItemIndex         := dm.tblconf.FieldByName('ELGIN_ComprovanteLoja').AsInteger;
   cbELGIN_SalvarLOG.Checked                := dm.tblconf.FieldByName('ELGIN_SalvarLOG').AsBoolean;
   cbcomprovantetefreduzido.Checked         := dm.tblconf.FieldByName('ELGIN_ImpressaoReduzida').AsBoolean;
   cbcomprovanteteflojasimplificado.Checked := dm.tblconf.FieldByName('ELGIN_ComprovanteSimplificado').AsBoolean;
   //---------------------------------------------------------------------------
   //  Configura��es da impressora
   edtporta_impressora_ESC_POS.Text := dm.tblconfIMPRESSORAPortaNome.Text;
   cbimpressora_ESC_POS.ItemIndex   := strtointdef(dm.tblconfIMPRESSORAModelo.Text,4);
   edtavanco.Text                   := dm.tblconfIMPRESSORAAvanco.Text;
   //---------------------------------------------------------------------------
end;

procedure Tfrmconfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   frmconfig.Release;
end;

procedure Tfrmconfig.FormCreate(Sender: TObject);
begin
   pgc.ActivePageIndex := 0;
end;

procedure Tfrmconfig.SpeedButton1Click(Sender: TObject);
begin
   SA_Adm_TEF_Elgin;
end;

end.