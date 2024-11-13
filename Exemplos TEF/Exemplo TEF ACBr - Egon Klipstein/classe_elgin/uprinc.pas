unit uprinc;

interface

uses
  uElginTEF,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.UITypes,
  System.Variants,
  System.Classes,
  System.DateUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Mask, Vcl.Buttons,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Imaging.jpeg;

type
  Tfrmprinc = class(TForm)
    pntitulo: TPanel;
    pnrodape: TPanel;
    btreiniciarvenda: TSpeedButton;
    btpagar: TSpeedButton;
    edttotal: TMaskEdit;
    Label1: TLabel;
    tblvenda: TFDMemTable;
    dtsvenda: TDataSource;
    tblvendadescricao: TStringField;
    tblvendaqtde: TFloatField;
    tblvendapreco: TFloatField;
    tblvendatotal: TFloatField;
    DBGridprod: TDBGrid;
    edtdigitar: TMaskEdit;
    Label2: TLabel;
    edtqtde: TMaskEdit;
    Label3: TLabel;
    edtpreco: TMaskEdit;
    Label4: TLabel;
    Label5: TLabel;
    rbtipo: TRadioGroup;
    btconfig: TSpeedButton;
    btrelatorio: TSpeedButton;
    rbforma: TRadioGroup;
    rbfinanciamento: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure edtdigitarKeyPress(Sender: TObject; var Key: Char);
    procedure btreiniciarvendaClick(Sender: TObject);
    procedure edtdigitarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpagarClick(Sender: TObject);
    procedure btconfigClick(Sender: TObject);
    procedure btrelatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprinc: Tfrmprinc;

Procedure SA_Adm_TEF_Elgin;
function SA_ELGINPagar(forma:string;valor:real;documento : string = ''):boolean;
procedure SA_Cancelar_TEF_ELGIN( NSU : string; data : tdate; valor : real);

implementation

{$R *.dfm}

uses uconfig, udm, urelatorio;

//------------------------------------------------------------------------------
Procedure SA_Adm_TEF_Elgin;
var
   TEF_Elgin : TElginTEF;
begin
   //---------------------------------------------------------------------------
   TEF_Elgin := TElginTEF.Create;
   TEF_Elgin.TEFTextoPinPad      := 'MKM Automacao';
   //---------------------------------------------------------------------------
   TEF_Elgin.ComprovanteLoja     := TtpImpressao(dm.tblconf.FieldByName('ELGIN_ComprovanteLoja').AsInteger);  // Perguntar
   TEF_Elgin.ComprovanteCliente  := TtpImpressao(dm.tblconf.FieldByName('ELGIN_ComprovanteCliente').AsInteger);  // Perguntar
   TEF_Elgin.SalvarLog           := dm.tblconf.FieldByName('ELGIN_SalvarLOG').AsBoolean;
   TEF_Elgin.ImpressaoReduzida   := dm.tblconf.FieldByName('ELGIN_ImpressaoReduzida').AsBoolean;
   TEF_Elgin.ViaLojaSimplificada := dm.tblconf.FieldByName('ELGIN_ComprovanteSimplificado').AsBoolean;
   //---------------------------------------------------------------------------
   TEF_Elgin.tpOperacaoADM := tpOpPerguntar;
   //---------------------------------------------------------------------------
   TEF_Elgin.SA_Administrativo;
   while TEF_Elgin.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   TEF_Elgin.Free;
end;

//------------------------------------------------------------------------------
//    Rotina de cancelamento de TEF ELGIN
//------------------------------------------------------------------------------
procedure SA_Cancelar_TEF_ELGIN( NSU : string; data : tdate; valor : real);
var
   TEF_Elgin : TElginTEF;
//   tabelas   : TStringList;
begin
   //---------------------------------------------------------------------------
   TEF_Elgin                      := TElginTEF.Create;
   TEF_Elgin.TEFTextoPinPad       := 'MKM Automacao';

   TEF_Elgin.ComprovanteLoja      := TtpImpressao(dm.tblconf.FieldByName('ELGIN_ComprovanteLoja').AsInteger);  // Perguntar
   TEF_Elgin.ComprovanteCliente   := TtpImpressao(dm.tblconf.FieldByName('ELGIN_ComprovanteCliente').AsInteger);  // Perguntar
   TEF_Elgin.SalvarLog            := dm.tblconf.FieldByName('ELGIN_SalvarLOG').AsBoolean;
   TEF_Elgin.ImpressaoReduzida    := dm.tblconf.FieldByName('ELGIN_ImpressaoReduzida').AsBoolean;
   TEF_Elgin.ViaLojaSimplificada  := dm.tblconf.FieldByName('ELGIN_ComprovanteSimplificado').AsBoolean;
   //---------------------------------------------------------------------------
   TEF_Elgin.tpOperacaoADM := tpOpCancelamento;
   TEF_Elgin.CancelarNSU   := NSU;     // N�mero do NSU retornado pela transa��o da ELGIN
   TEF_Elgin.CancelarData  := data;    // Data da opera��o
   TEF_Elgin.CancelarValor := valor;   // Valor da opera��o
   //---------------------------------------------------------------------------
   TEF_Elgin.SA_AdmCancelamento;
   while TEF_Elgin.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   beep;
   if TEF_Elgin.Estornado then
      showmessage('Cancelamento com sucesso !')
   else
      showmessage('Houve erro no cancelamento !');
   //---------------------------------------------------------------------------
   TEF_Elgin.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Pagamento ELGIN
//------------------------------------------------------------------------------
function SA_ELGINPagar(forma:string;valor:real;documento : string = ''):boolean;
var
   TEF_Elgin   : TElginTEF;
   comprovante : TStringList;
begin
   //---------------------------------------------------------------------------
   TEF_Elgin                      := TElginTEF.Create;
   TEF_Elgin.TEFTextoPinPad       := 'MKM Automacao';
   TEF_Elgin.ComprovanteLoja      := TtpImpressao(dm.tblconf.FieldByName('ELGIN_ComprovanteLoja').AsInteger);  // Perguntar
   TEF_Elgin.ComprovanteCliente   := TtpImpressao(dm.tblconf.FieldByName('ELGIN_ComprovanteCliente').AsInteger);  // Perguntar
   TEF_Elgin.SalvarLog            := dm.tblconf.FieldByName('ELGIN_SalvarLOG').AsBoolean;
   TEF_Elgin.ImpressaoReduzida    := dm.tblconf.FieldByName('ELGIN_ImpressaoReduzida').AsBoolean;
   TEF_Elgin.ViaLojaSimplificada  := dm.tblconf.FieldByName('ELGIN_ComprovanteSimplificado').AsBoolean;
   //---------------------------------------------------------------------------
   TEF_Elgin.Valor               := valor;     // Valor da transa��o a ser realizada
   TEF_Elgin.Forma               := forma;     // Forma de pagamento descritiva para apresentar na tela
   TEF_Elgin.Documento           := documento; // Documento a ser enviado para a transa��o - Opcional
   TEF_Elgin.TpCartaoOperacaoTEF := TTpCartaoOperacaoTEF(frmprinc.rbforma.ItemIndex);     // Tipo de opera��o - Cart�o de Cr�dito, D�bito, voucher, Pix, etc
   TEF_Elgin.FormaPgto           := TtpFormaPgto(frmprinc.rbtipo.ItemIndex);              // Forma da opera��o - A vista, parcelado, pr� datado, etc
   TEF_Elgin.tpFinanciamento     := TtpFinanciamento(frmprinc.rbfinanciamento.ItemIndex); // Tipo de financiamento, Lojista, administradora
   TEF_Elgin.QtdeParcelas        := 1;  // Quantidade de parcelas
   if TEF_Elgin.FormaPgto=tpFormaParcelado then  // Se for parcelado, definir para 3 parcelas - Na implementa��o real, providencie um or�gem para informar
      TEF_Elgin.QtdeParcelas     := 3;  // Quantidade de parcelas = 3 para transacionar, pois o modo parcelado requer mais de 1 parcela
   //---------------------------------------------------------------------------
   TEF_Elgin.SA_Configurar_TEF;
   if TEF_Elgin.TpCartaoOperacaoTEF<>tpPIX then  // Se n�o for PIX fazer transa��o com cart�o normal
      TEF_Elgin.SA_ProcessarPagamento    // Cart�o normal
   else
      TEF_Elgin.SA_PagamentoPIX;   // Pagamento PIX
   //---------------------------------------------------------------------------
   while TEF_Elgin.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_Elgin.NSU<>'';
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   dm.tbltef.Close;
   dm.tbltef.Open;
   dm.tbltef.EmptyDataSet;
   if fileexists(GetCurrentDir+'\tef.xml') then
      dm.tbltef.LoadFromFile(GetCurrentDir+'\tef.xml');
   //  Incluindo o registro no dataset
   dm.tbltef.Append;
   dm.tbltef.FieldByName('dh').AsDateTime                 := strtodatetimedef(TEF_Elgin.dataHoraTransacao,now);
   dm.tbltef.FieldByName('forma').AsString                 := TEF_Elgin.Forma;
   dm.tbltef.FieldByName('NSU').AsString                   := TEF_Elgin.NSU;
   dm.tbltef.FieldByName('valor').AsFloat                  := TEF_Elgin.Valor;
   dm.tbltef.FieldByName('Rede_Adquirente').AsString       := TEF_Elgin.rede;
   dm.tbltef.FieldByName('Pagamento_Cartao').AsString      := TEF_Elgin.tBand;
   dm.tbltef.FieldByName('Pagamento_Tipo').AsString        := TEF_Elgin.Nome_do_Produto;
   dm.tbltef.FieldByName('Codigo_de_Autorizacao').AsString := TEF_Elgin.cAut;
   dm.tbltef.FieldByName('Documento_numero').AsString      := TEF_Elgin.Documento;
   dm.tbltef.Post;
   //---------------------------------------------------------------------------
   dm.tbltef.SaveToFile(GetCurrentDir+'\tef.xml');   // Salvando o arquivo XML
   //---------------------------------------------------------------------------
   //  Salvando os comprovantes em TXT
   comprovante      := TStringList.Create;
   //   Salvar comprovante da loja
   comprovante.Text := StringReplace(TEF_Elgin.TextoComprovanteLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
   comprovante.SaveToFile(GetCurrentDir+'\comprovantes\compr_loja_'+TEF_Elgin.NSU+'.txt');
   //   Salvar comprovante do cliente
   comprovante.Text := StringReplace(TEF_Elgin.TextoComprovanteCli,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
   comprovante.SaveToFile(GetCurrentDir+'\comprovantes\compr_cliente_'+TEF_Elgin.NSU+'.txt');

   comprovante.Free;
   //---------------------------------------------------------------------------



   TEF_Elgin.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------


procedure SomarVenda;
var
   total : real;
begin
   total := 0;
   frmprinc.tblvenda.First;
   while not frmprinc.tblvenda.Eof do
      begin
         total := total + frmprinc.tblvenda.FieldByName('total').AsFloat;
         frmprinc.tblvenda.Next;
      end;
   frmprinc.edttotal.Text := formatfloat('###,##0.00',total);
end;

procedure Tfrmprinc.btconfigClick(Sender: TObject);
begin
   Application.CreateForm(Tfrmconfig, frmconfig);
   frmconfig.ShowModal;
end;

procedure Tfrmprinc.btpagarClick(Sender: TObject);
begin
   if strtofloatdef(edttotal.Text,0)=0 then
      begin
         beep;
         ShowMessage('Venda sem valor. Opera��o imposs�vel !');
         exit;
      end;
   //---------------------------------------------------------------------------
   SA_ELGINPagar(rbforma.Items[rbforma.ItemIndex],strtofloatdef(edttotal.Text,1),'123456');
   //---------------------------------------------------------------------------
end;

procedure Tfrmprinc.btreiniciarvendaClick(Sender: TObject);
begin
   if messagedlg('Deseja reiniciar a venda em andamento ?!',mtconfirmation,[mbyes,mbno],0)= mryes then
      begin
         tblvenda.EmptyDataSet;
         SomarVenda;

      end;

end;

procedure Tfrmprinc.btrelatorioClick(Sender: TObject);
begin
   Application.CreateForm(Tfrmrelatorio, frmrelatorio);
   frmrelatorio.ShowModal;
end;

procedure Tfrmprinc.edtdigitarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case key of
      vk_f5:btpagar.Click;
      vk_f9:btreiniciarvenda.Click;
   end;
end;

procedure Tfrmprinc.edtdigitarKeyPress(Sender: TObject; var Key: Char);
begin
   if key='*' then
      begin
         key := #0;
         try
            edtqtde.Text    := formatfloat('###,##0.000',strtofloatdef(edtdigitar.Text,1));
            edtdigitar.Text := '';
         except
            edtqtde.Text    := formatfloat('###,##0.000',1);
         end;
      end;
   if key='=' then
      begin
         key := #0;
         try
            edtpreco.Text   := formatfloat('###,##0.000',strtofloatdef(edtdigitar.Text,1));
            edtdigitar.Text := '';
         except
            edtqtde.Text    := formatfloat('###,##0.000',1);
         end;
      end;
   //---------------------------------------------------------------------------
   if key=#13 then
      begin
         //---------------------------------------------------------------------
         if edtdigitar.Text='' then
            edtdigitar.Text := 'PAO COM BANHA';
         if strtofloatdef(edtqtde.Text,1)=0 then
            edtqtde.Text := '1';
         if strtofloatdef(edtpreco.Text,1)=0 then
            edtpreco.Text := '1';
         //---------------------------------------------------------------------
         tblvenda.Append;
         tblvenda.FieldByName('descricao').AsString := edtdigitar.Text;
         tblvenda.FieldByName('qtde').AsFloat       := strtofloatdef(edtqtde.Text,1);
         tblvenda.FieldByName('preco').AsFloat      := strtofloatdef(edtpreco.Text,1);
         tblvenda.FieldByName('total').AsFloat      := strtofloatdef(edtqtde.Text,1)*strtofloatdef(edtpreco.Text,1);
         tblvenda.Post;
         SomarVenda;
         edtdigitar.Text := '';
         edtqtde.Text    := formatfloat('###,##0.000',1);
         edtpreco.Text   := formatfloat('###,##0.000',0);
      end;
end;

procedure Tfrmprinc.FormActivate(Sender: TObject);
begin
   frmprinc.WindowState := wsMaximized;
   tblvenda.Open;
   tblvenda.EmptyDataSet;
   edtdigitar.SetFocus;
end;

end.