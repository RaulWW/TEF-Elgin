unit uElginTEF;

interface

uses
   ACBrPosPrinter,
   ACBrImage,
   ACBrDelphiZXingQRCode,
   uescpos,
   TypInfo,
   vcl.forms,
   Vcl.Graphics,
   System.JSON,
   System.SysUtils,
   system.DateUtils,
   system.Classes,
   uwebtefmp;

type
   //---------------------------------------------------------------------------
   TTpCartaoOperacaoTEF  = (tpPerguntar , tpCartaoCredito , tpCartaoDebito , tpVoucher , tpFrota , tpPrivateLabel,tpPIX);
   TtpImpressao          = (tpiImprimir, tpiPerguntar , tpiNaoImprimir);
   TtpComprovante        = (tpLoja, tpCliente);
   TtpFormaPgto          = (tpFormaPerguntar , tpFormaVista , tpFormaParcelado , tpFormaPreDatado);
   TtpFinanciamento      = (tpFinPerguntar , tpFinLojista , tpFinAdministradora);     // tipoFinanciamento
   TtpOperacaoADM        = (tpOpPerguntar , tpOpCancelamento , tpOpPendencias , tpOpReimpressao);
   //---------------------------------------------------------------------------
   TTefRetorno = record
      //------------------------------------------------------------------------
      codigo                           : integer;
      //------------------------------------------------------------------------
      automacao_coleta_opcao           : string;
      automacao_coleta_palavra_chave   : string;
      automacao_coleta_retorno         : string;
      automacao_coleta_sequencial      : string;
      automacao_coleta_tipo            : string;
      automacao_coleta_mascara         : string;
      mensagemResultado                : string;
      //------------------------------------------------------------------------
      cnpjCredenciadora                : string;
      codigoAutorizacao                : string;
      comprovanteDiferenciadoLoja      : string;
      comprovanteDiferenciadoPortador  : string;
      dataHoraTransacao                : string;
      formaPagamento                   : string;
      identificadorEstabelecimento     : string;
      identificadorPontoCaptura        : string;
      loja                             : string;
      nomeBandeira                     : string;
      nomeEstabelecimento              : string;
      nomeProduto                      : string;
      nomeProvedor                     : string;
      nsuTerminal                      : string;
      nsuTransacao                     : string;
      panMascarado                     : string;
      resultadoTransacao               : string;
      retorno                          : string;
      sequencial                       : string;
      servico                          : string;
      tipoCartao                       : string;
      transacao                        : string;
      uniqueID                         : string;
      valorTotal                       : string;
      linhasMensagemRetorno            : TStringList;
      //------------------------------------------------------------------------
   end;
   //---------------------------------------------------------------------------
   TElginTEF = class
   private
      //------------------------------------------------------------------------
      LTEFTextoPinPad      : string;
      LtpOperacaoADM       : TtpOperacaoADM;
      LComprovanteLoja     : TtpImpressao;
      LComprovanteCliente  : TtpImpressao;
      LImpressaoReduzida   : boolean;
      LViaLojaSimplificada : boolean;
      LEstornado           : boolean;
      //------------------------------------------------------------------------
      //   Cancelamento
      //------------------------------------------------------------------------
      LCancelarNSU        : string;
      LCancelarData       : TDate;
      LCancelarValor      : real;
      //------------------------------------------------------------------------
      LSalvarLog          : boolean;
      //------------------------------------------------------------------------
      LSequencial         : integer;
      //------------------------------------------------------------------------
      //  Dados da opera��o
      LForma                : string;
      LValor                : real;
      LTpCartaoOperacaoTEF  : TTpCartaoOperacaoTEF;
      LFormaPgto            : TtpFormaPgto;
      LtpFinanciamento      : TtpFinanciamento;
      TpComprovanteImprimir : TtpComprovante;
      LQtdeParcelas         : integer;
      LDocumento            : string; // Documento da venda
      //------------------------------------------------------------------------
      LNSU                  : string;
      LNome_do_Produto      : string;
      LcAut                 : string;
      Lrede                 : string;
      LtBand                : string;
      LExecutando           : boolean;
      LCNPJAdquirente       : string;
      LdataHoraTransacao    : string;
      LTextoComprovanteLoja : string;
      LTextoComprovanteCli  : string;
      //------------------------------------------------------------------------
      LPortaImpressora      : string;                // Porta da impressora
      LAvanco               : integer;               // Avan�o de linhas ao finalizar  a impress�o
      LModeloImpressoraACBR : TACBrPosPrinterModelo; // Modelo de impressora - Protocolo ESC POS
      LPaginaDeCodigo       : TACBrPosPaginaCodigo;  //  P�gina de c�digo da impressora
      //------------------------------------------------------------------------
      procedure SA_SalvarLog(titulo,dado: string);
      function SA_TpCartaoOperacaoTEFtoINT(tipoCartao : TTpCartaoOperacaoTEF):integer;
      function SA_tpOperacaoADMToInt(tipo:ttpOperacaoADM):integer;
      function SA_ParsingTEF(conteudo : string):TTefRetorno;
      function SA_Opcoes(opcoes:string):TStringList;
      procedure SA_Inicializar_ESCPOS;
      function SA_RecuperarLinhasMensagem(mensagem:string):TStringList;
      function SA_ResumirComprovante(texto:TStringList):TStringList;
      function SA_GerarComprovanteSimplificado:TStringList;
      function transform(valor:real):string;
      procedure SA_Salva_Arquivo_Incremental(linha,nome_arquivo:string);
      function untransform(palavra:string):real;
      function vale(data:string):boolean;
      function SA_Limpacampo(campo:string):string;

      procedure SA_MostrarBtCancelarT;
      procedure SA_DesativarBtCancelarT;
      procedure SA_MostramensagemT;
      procedure SA_CriarMenuT;
      procedure SA_DesativarMenuT;
   public
      //------------------------------------------------------------------------
      GerenciadorImpressao : TESCPos;
      //------------------------------------------------------------------------
      constructor Create();
      //------------------------------------------------------------------------
      procedure SA_Configurar_TEF;
      function SA_Inicializar_TEF:boolean;
      //------------------------------------------------------------------------
      procedure SA_ProcessarPagamento;
      procedure SA_ImprimirComprovante(comprovante:TStringList;pergunta:string);
      function SA_PerguntarOpcoes(opcoes:TStringList;mensagem:string):integer;
      //------------------------------------------------------------------------
      procedure SA_Administrativo;
      procedure SA_AdmCancelamento;
      procedure SA_PagamentoPIX;
      //------------------------------------------------------------------------
      // Configura��es
      property TEFTextoPinPad       : string read LTEFTextoPinPad write LTEFTextoPinPad;
      property tpOperacaoADM        : TtpOperacaoADM read LtpOperacaoADM write LtpOperacaoADM;
      //------------------------------------------------------------------------
      property ComprovanteLoja      : TtpImpressao read LComprovanteLoja write LComprovanteLoja;
      property ComprovanteCliente   : TtpImpressao read LComprovanteCliente write LComprovanteCliente;
      //------------------------------------------------------------------------
      property SalvarLog            : boolean read LSalvarLog write LSalvarLog;
      //------------------------------------------------------------------------
      property Documento            : string read LDocumento write LDocumento;
      property Forma                : string read LForma write LForma;  // Forma de pagamento para exibir na tela do TEF
      property Valor                : real read LValor write LValor;    // Valor da transa��o
      property TpCartaoOperacaoTEF  : TTpCartaoOperacaoTEF read LTpCartaoOperacaoTEF write LTpCartaoOperacaoTEF;  // Tipo de opera��o do cart�o
      property FormaPgto            : TtpFormaPgto read LFormaPgto write LFormaPgto;
      property tpFinanciamento      : TtpFinanciamento read LtpFinanciamento write LtpFinanciamento;
      property QtdeParcelas         : integer read LQtdeParcelas write LQtdeParcelas;
      //------------------------------------------------------------------------
      property CancelarNSU          : string read LCancelarNSU write LCancelarNSU;
      property CancelarData         : TDate read LCancelarData write LCancelarData;
      property CancelarValor        : real read LCancelarValor write LCancelarValor;
      property Estornado            : boolean read LEstornado write LEstornado;
      //------------------------------------------------------------------------
      property dataHoraTransacao    : string read LdataHoraTransacao;
      property NSU                  : string read LNSU;
      property Nome_do_Produto      : string read LNome_do_Produto;
      property cAut                 : string read LcAut;
      property rede                 : string read Lrede;
      property tBand                : string read LtBand;
      property Executando           : boolean read LExecutando;
      property CNPJAdquirente       : string read LCNPJAdquirente;
      property TextoComprovanteLoja : String read LTextoComprovanteLoja write LTextoComprovanteLoja;
      property TextoComprovanteCli  : String read LTextoComprovanteCli write LTextoComprovanteCli;
      property ImpressaoReduzida    : boolean read LImpressaoReduzida write LImpressaoReduzida;
      property ViaLojaSimplificada  : boolean read LViaLojaSimplificada write LViaLojaSimplificada;
      //------------------------------------------------------------------------
      property PortaImpressora      : string                        read LPortaImpressora      write LPortaImpressora;  // Porta da impressora
      property Avanco               : integer                       read LAvanco               write LAvanco;  // Avan�o de linhas ao finalizar  a impress�o
      property ModeloImpressoraACBR : TACBrPosPrinterModelo         read LModeloImpressoraACBR write LModeloImpressoraACBR;  // Modelo do protocolo da impressora
      property PaginaDeCodigo       : TACBrPosPaginaCodigo          read LPaginaDeCodigo       write LPaginaDeCodigo;  //  P�gina de c�digo da impressora
      //------------------------------------------------------------------------
   end;
  //----------------------------------------------------------------------------
  //   Declara��es de bibliotecas contidas na DLL da ELGIN
  //----------------------------------------------------------------------------
  function SetClientTCP(ip:PAnsiChar; porta:Integer):PAnsiChar;stdcall; external 'E1_Tef01.dll';
  function ConfigurarDadosPDV(textoPinpad:PAnsiChar; versaoAC:PAnsiChar; nomeEstabelecimento:PAnsiChar; loja:PAnsiChar; identificadorPontoCaptura:PAnsiChar):PAnsiChar; stdcall; external 'E1_Tef01.dll';
  function IniciarOperacaoTEF(dadosCaptura:PAnsiChar):PAnsiChar; stdcall; external 'E1_Tef01.dll';
  function RecuperarOperacaoTEF(dadosCaptura:PAnsiChar):PAnsiChar; stdcall; external 'E1_Tef01.dll';
  function RealizarPagamentoTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;stdcall;external 'E1_Tef01.dll';
  function RealizarPixTEF(dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;stdcall;external 'E1_Tef01.dll';
  function RealizarAdmTEF(codigoOperacao:Integer; dadosCaptura:PAnsiChar; novaTransacao:Boolean):PAnsiChar;stdcall;external 'E1_Tef01.dll';
  function ConfirmarOperacaoTEF(id:Integer; acao:Integer):PAnsiChar; stdcall; external 'E1_Tef01.dll';
  function FinalizarOperacaoTEF(id:Integer):PAnsiChar; stdcall; external 'E1_Tef01.dll';
  function RealizarColetaPinPad(tipoColeta: integer; confirmar: boolean): PAnsiChar; stdcall; external 'E1_Tef01.dll';
  function ConfirmarCapturaPinPad(tipoCaptura: integer; dadosCaptura: PAnsiChar): PAnsiChar; stdcall; external 'E1_Tef01.dll';
  //----------------------------------------------------------------------------
implementation

{ TElginTEF }

constructor TElginTEF.Create;
begin
   LExecutando          := true;
   LSequencial          := 0;
   LSalvarLog           := true;
   LFormaPgto           := tpFormaPerguntar;
   LtpFinanciamento     := tpFinPerguntar;
   LQtdeParcelas        := 0;
   LImpressaoReduzida   := false;
   LViaLojaSimplificada := false;
   //---------------------------------------------------------------------------
   SA_Inicializar_ESCPOS;
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;


procedure TElginTEF.SA_AdmCancelamento;
var
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transa��o
   inicializar  : boolean;  // Flag para sinalizar se foi poss�vel inicializar o TEF ELGIN
   resultado    : string;
   sair         : boolean;
   RespReqTEF   : TTefRetorno; // Retorno da requisi��o inicial de ADM
   RespConsTEF  : TTefRetorno; // Retorno da requisi��o de ADM
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   //---------------------------------------------------------------------------
   DadoColeta       : string;   // Dado obtido do operador para a coleta
   conteudo_default : string;  // Informa��o que vai entrar no campo
   opcoesColeta     : TStringList;
   opcaoColeta      : integer;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := '';
   frmwebtef.lbvalor.Caption  := '';
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   SA_MostrarADM;
   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------
   LExecutando := true;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      inicializar := SA_Inicializar_TEF;   // Inicializando o TEF
      //------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('Resposta FINALIZAR',resultado);
            frmwebtef.mensagem := 'Erro na inicializa��o do TEF';
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
            lExecutando := false;
            sair        := true;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      if not sair  then
         begin
            //------------------------------------------------------------------
            inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada � DLL
            payload := TJsonObject.Create;
            payload.AddPair('sequencial', LSequencial.ToString);
            payload.AddPair('transacao_data',formatdatetime('dd/MM/yy',LCancelarData));
            payload.AddPair('transacao_nsu',LCancelarNSU);
            payload.AddPair('transacao_valor',trim(stringreplace(transform(CancelarValor),',','.',[rfReplaceAll])));
            //------------------------------------------------------------------
            frmwebtef.mensagem := 'Iniciando CANCELAMENTO ADM...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            SA_SalvarLog('CANCELAMENTO ADM:',payload.ToString);
            resultado :=  UTF8ToString(RealizarAdmTEF( SA_tpOperacaoADMToInt(LtpOperacaoADM) , PAnsiChar(AnsiString(payload.ToString)), True));
            SA_SalvarLog('Resposta CANCELAMENTO ADM:',resultado);
            //------------------------------------------------------------------
            RespReqTEF  := SA_ParsingTEF(resultado);
            RespConsTEF := RespReqTEF;
            //------------------------------------------------------------------
            while not sair do
               begin
                  //------------------------------------------------------------
                  if RespConsTEF.retorno='' then  // Tem que processar o retorno
                     begin
                        //------------------------------------------------------
                        //  Consultar TEF
                        //------------------------------------------------------
                        if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao<>'') then
                           begin
                              //------------------------------------------------
                              //  Criar menu de op��es
                              //------------------------------------------------
                              opcoesColeta := SA_Opcoes(RespConsTEF.automacao_coleta_opcao);
                              //------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              frmwebtef.opcoes   := opcoesColeta;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                              //------------------------------------------------
                              opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespConsTEF.mensagemResultado);   // Apanhando a op��o do menu
                              if opcaoColeta<>-1 then
                                 DadoColeta   := opcoesColeta[opcaoColeta-1]  // Obtendo dado para a coleta
                              else
                                 DadoColeta   := '';   // Definindo o valor vazio para coleta
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                              //------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao='') then
                           begin
                              //------------------------------------------------
                              //  Coletar dado string do teclado
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,
                              procedure
                                 begin
                                    SA_ColetarValor(RespConsTEF.mensagemResultado,'',RespConsTEF.automacao_coleta_palavra_chave='transacao_administracao_senha');
                                 end);
                              //------------------------------------------------
                              DadoColeta              := '';
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              while (frmwebtef.dado_digitado='') and(not frmwebtef.Cancelar) do
                                 begin
                                    sleep(10);
                                 end;
                              DadoColeta   := frmwebtef.dado_digitado;
                              frmwebtef.pncaptura.Visible := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='N') then
                           begin
                              //------------------------------------------------
                              //  Coletar dado numerico do teclado
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'',false);
                                 end);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',',',#8]
                              else
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (untransform(frmwebtef.dado_digitado)>0)  then
                                       begin
                                          if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                             DadoColeta := trim(stringreplace(transform(untransform(frmwebtef.dado_digitado)),',','.',[rfReplaceAll]))
                                          else
                                             DadoColeta := frmwebtef.dado_digitado;
                                       end
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inv�lido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='D') then
                           begin
                              //------------------------------------------------
                              //  Coletar dado DATA do teclado
                              //------------------------------------------------
                              conteudo_default := '';
                              if uppercase(RespConsTEF.mensagemResultado)='DATA DO EXTRATO' then
                                 conteudo_default := formatdatetime('dd/mm/yyyy',date);

                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'99/99/9999',false,conteudo_default);
                                 end);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //------------------------------------------
                                    sleep(10);
                                    //------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (vale(frmwebtef.dado_digitado)) then
                                       DadoColeta := formatdatetime(RespConsTEF.automacao_coleta_mascara,strtodate(frmwebtef.dado_digitado))
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inv�lido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='') and (RespConsTEF.automacao_coleta_retorno='0') then
                           begin
                              //------------------------------------------------
                              //  Mostrar mensagem somente
                              //------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        if (RespConsTEF.automacao_coleta_tipo='') and (RespConsTEF.automacao_coleta_opcao='') and (RespConsTEF.automacao_coleta_retorno='0') then
                           begin
                              //------------------------------------------------
                              //   Fazer Consulta
                              //------------------------------------------------                              
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                              SA_SalvarLog('CONSULTAR:',payload.ToString);   // Salvar LOG
                              //------------------------------------------
                              resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                              SA_SalvarLog('Resposta CONSULTAR:',resultado);   // Salvar LOG
                              RespConsTEF  := SA_ParsingTEF(resultado);
                              sair := false;
                              //------------------------------------------------                              
                           end
                        else 
                           begin
                              if DadoColeta<>'' then   // Foi digitado algum dado
                                 begin
                                    //------------------------------------------
                                    //   Enviar o dado coletado
                                    //   � necess�rio informar os dados coletados do operador
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'ENVIANDO DADOS PARA TEF';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_informacao', DadoColeta);
                                    SA_SalvarLog('INFORMAR COLETA:',payload.ToString);   // Salvar LOG
                                    resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    SA_SalvarLog('Resposta INFORMAR COLETA:',resultado);   // Salvar LOG
                                    RespConsTEF   := SA_ParsingTEF(resultado);
                                    DadoColeta    := '';
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    // Finalizar a opera��o
                                    //------------------------------------------
                                    resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a opera��o de TEF
                                    SA_SalvarLog('Resposta FINALIZAR:',resultado);   // Salvar LOG
                                    sair := true;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end
                  else if (RespConsTEF.retorno='0') or (RespConsTEF.retorno='1') then
                     begin
                        //------------------------------------------------------
                        //   Verificar se h� impressos a serem executados
                        //------------------------------------------------------
                        LSequencial := strtointdef(RespConsTEF.sequencial,0);
                        SA_SalvarLog('CONFIRMAR:','Nro Sequencial = '+RespConsTEF.sequencial);   // Salvar LOG
                        resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,1));

                        SA_SalvarLog('Resposta CONFIRMAR:',resultado);   // Salvar LOG

                        LEstornado := true;
                        if RespConsTEF.comprovanteDiferenciadoLoja<>'' then
                           begin
                              if LComprovanteLoja<>tpiNaoImprimir then
                                 begin
                                    TpComprovanteImprimir            := tpLoja;
                                    comprovanteDiferenciadoLoja      := TStringList.Create;
                                    comprovanteDiferenciadoLoja.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                    SA_ImprimirComprovante(comprovanteDiferenciadoLoja,'Imprimir comprovante da loja ?');
                                    comprovanteDiferenciadoLoja.Free;
                                 end;
                           end;
                        if RespConsTEF.comprovanteDiferenciadoPortador<>'' then
                           begin
                              if LComprovanteCliente<>tpiNaoImprimir then
                                 begin
                                    TpComprovanteImprimir                := tpCliente;
                                    comprovanteDiferenciadoPortador      := TStringList.Create;
                                    comprovanteDiferenciadoPortador.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                    SA_ImprimirComprovante(comprovanteDiferenciadoPortador,'Imprimir comprovante do cliente ?');
                                    comprovanteDiferenciadoPortador.Free;
                                 end;
                           end;
                        //------------------------------------------------------
                        resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a opera��o de TEF
                        SA_SalvarLog('Resposta FINALIZAR:',resultado);   // Salvar LOG
                        sair := true;
                        //------------------------------------------------------
                     end
                  else if RespConsTEF.retorno>='3' then
                     begin
                        frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                        //------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        //------------------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                        while not frmwebtef.Cancelar do
                           begin
                              sleep(50);
                           end;
                        //------------------------------------------------------------------
                        lExecutando := false;
                        sair        := true;
                        //------------------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
         end;
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------
end;

procedure TElginTEF.SA_Administrativo;
var
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transa��o
   inicializar  : boolean;  // Flag para sinalizar se foi poss�vel inicializar o TEF ELGIN
   resultado    : string;
   sair         : boolean;
   RespReqTEF   : TTefRetorno; // Retorno da requisi��o inicial de ADM
   RespConsTEF  : TTefRetorno; // Retorno da requisi��o de ADM
   DadoColeta   : string;   // Dado obtido do operador para a coleta
   //---------------------------------------------------------------------------
   opcoesColeta  : TStringList;
   opcaoColeta   : integer;
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   //---------------------------------------------------------------------------
   conteudo_default : string;  // Informa��o que vai entrar no campo
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;

   SA_MostrarADM;
   //---------------------------------------------------------------------------
   LExecutando := true;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      sair        := false;
      inicializar := SA_Inicializar_TEF;   // Inicializando o TEF
      //------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('Resposta FINALIZAR',resultado);
            frmwebtef.mensagem := 'Erro na inicializa��o do TEF';
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
            lExecutando := false;
            sair        := true;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------

      if not sair  then
         begin
            //------------------------------------------------------------------
            inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada � DLL
            payload := TJsonObject.Create;
            payload.AddPair('sequencial', LSequencial.ToString);
            //------------------------------------------------------------------
            frmwebtef.mensagem := 'Iniciando ADM...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            SA_SalvarLog('ADM:',payload.ToString);
            resultado :=  UTF8ToString(RealizarAdmTEF( SA_tpOperacaoADMToInt(LtpOperacaoADM) , PAnsiChar(AnsiString(payload.ToString)), True));
            SA_SalvarLog('Resposta ADM:',resultado);
            //------------------------------------------------------------------
            RespReqTEF  := SA_ParsingTEF(resultado);
            //------------------------------------------------------------------
            if (RespReqTEF.retorno<>'') then   // Ocorreu um erro que exige a finaliza��o da opera��o
               begin
                  //------------------------------------------------------------
                  //   Mostrar a mensagem de erro na tela
                  //------------------------------------------------------------
                  resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a opera��o de TEF
                  SA_SalvarLog('Resposta FINALIZAR:',resultado);   // Salvar LOG
                  if RespReqTEF.mensagemResultado<>'' then   // Se o TEF mandou exibir alguma mensagem
                     frmwebtef.mensagem := RespReqTEF.mensagemResultado
                  else   // Sem mensagem nenhuma, criando uma padr�o
                     frmwebtef.mensagem := 'Ocorreu erro na requisi��o de pagamento...';
                  TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                  TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                  sair := true;
                  while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                     begin
                        sleep(50);
                     end;
                  //------------------------------------------------------------
               end
            else if RespReqTEF.retorno='' then   //   � necess�rio ficar monitorando e fazer coleta
               begin
                  //------------------------------------------------------------
                  RespConsTEF := RespReqTEF;
                  while not sair do
                     begin
                        //------------------------------------------------------
                        DadoColeta   := '';
                        if frmwebtef.Cancelar then
                           break;
                        //------------------------------------------------------
                        if RespConsTEF.automacao_coleta_tipo='X' then  // Tem que coletar um valor alfanumerico
                           begin
                              if RespConsTEF.automacao_coleta_opcao<>'' then   // Tem que abrir um Menu de op��es
                                 begin
                                    //------------------------------------------
                                    //  Criar menu de op��es
                                    //------------------------------------------
                                     opcoesColeta := SA_Opcoes(RespConsTEF.automacao_coleta_opcao);
                                     //---------------------------------------------------
                                     frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                                     frmwebtef.opcoes   := opcoesColeta;
                                     frmwebtef.opcao    := -1;
                                     frmwebtef.tecla    := '';
                                     frmwebtef.Cancelar := false;
                                     //---------------------------------------------------
                                     TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                     TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                     //---------------------------------------------------
                                     opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespConsTEF.mensagemResultado);   // Apanhando a op��o do menu
                                     if opcaoColeta<>-1 then
                                        DadoColeta   := opcoesColeta[opcaoColeta-1]  // Obtendo dado para a coleta
                                     else
                                        DadoColeta   := '';   // Definindo o valor vazio para coleta
                                     //---------------------------------------------------
                                     TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                     TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                 //------------------------------------------
                                 end
                              else   // Tem que coletar dados obtidos do teclado
                                 begin
                                    //------------------------------------------
                                    // Criar uma tela para digitar os dados
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,
                                    procedure
                                       begin
                                          SA_ColetarValor(RespConsTEF.mensagemResultado,'',RespConsTEF.automacao_coleta_palavra_chave='transacao_administracao_senha');
                                       end);
                                    //------------------------------------------
                                    DadoColeta              := '';
                                    frmwebtef.dado_digitado := '';
                                    frmwebtef.Cancelar      := false;
                                    while (frmwebtef.dado_digitado='') and(not frmwebtef.Cancelar) do
                                       begin
                                          sleep(10);
                                       end;
                                    DadoColeta   := frmwebtef.dado_digitado;
                                    frmwebtef.pncaptura.Visible := false;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end;
                           end
                        else if RespConsTEF.automacao_coleta_tipo='N' then  // Tem que coletar um valor numerico
                           begin
                              //------------------------------------------------
                              //  Tem que coletar dados num�ricos
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'',false);
                                 end);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',',',#8]
                              else
                                 frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (untransform(frmwebtef.dado_digitado)>0)  then
                                       begin
                                          if RespConsTEF.automacao_coleta_palavra_chave='transacao_valor' then
                                             DadoColeta := trim(stringreplace(transform(untransform(frmwebtef.dado_digitado)),',','.',[rfReplaceAll]))
                                          else
                                             DadoColeta := frmwebtef.dado_digitado;
                                       end
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inv�lido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if RespConsTEF.automacao_coleta_tipo='D' then  // Tem que coletar um valor numerico
                           begin
                              //----------------------------------------------------
                              //   Coletar Data do operador
                              //----------------------------------------------------
                              conteudo_default := '';
                              if uppercase(RespConsTEF.mensagemResultado)='DATA DO EXTRATO' then
                                 conteudo_default := formatdatetime('dd/mm/yyyy',date);

                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                 begin
                                   SA_ColetarValor(RespConsTEF.mensagemResultado,'99/99/9999',false,conteudo_default);
                                 end);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              DadoColeta              := '';
                              while (DadoColeta='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (vale(frmwebtef.dado_digitado)) then
                                       DadoColeta := formatdatetime(RespConsTEF.automacao_coleta_mascara,strtodate(frmwebtef.dado_digitado))
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inv�lido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                           end
                        else if RespConsTEF.automacao_coleta_tipo='' then  // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //   �penas mostrar uma mensagem na tela e verificar se a opera��o foi conclu�da
                              //------------------------------------------------
                              //   Mostrar a mensagem
                              //------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        if RespConsTEF.automacao_coleta_tipo<>'' then
                           begin
                              if DadoColeta<>'' then
                                 begin
                                    //------------------------------------------
                                    //   � necess�rio informar os dados coletados do operador
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'ENVIANDO DADOS PARA TEF';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_informacao', DadoColeta);
                                    SA_SalvarLog('INFORMAR COLETA:',payload.ToString);   // Salvar LOG
                                    resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    SA_SalvarLog('Resposta INFORMAR COLETA:',resultado);   // Salvar LOG
                                    RespConsTEF  := SA_ParsingTEF(resultado);
                                    sair := false;
                                    //------------------------------------------
                                    SA_Mostrar_Mensagem(false);
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    //   A coleta foi cancelada, finalizar a opera��o
                                    //------------------------------------------
                                    frmwebtef.mensagem := 'CANCELAR OPERA��O';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_retorno', '9');
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    //------------------------------------------
                                    SA_SalvarLog('CANCELAR COLETA:',payload.ToString);
                                    //------------------------------------------
                                    resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    //------------------------------------------
                                    SA_SalvarLog('Resposta CANCELAR COLETA:',resultado);
                                    //--------------------------------------------
                                    resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a opera��o de TEF
                                    SA_SalvarLog('Resposta FINALIZAR:',resultado);   // Salvar LOG
                                    RespConsTEF  := SA_ParsingTEF(resultado);
                                    frmwebtef.mensagem := 'Opera��o cancelada pelo operador...';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    sair := true;
                                    frmwebtef.Cancelar := false;
                                    while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    //------------------------------------------
                                 end;
                           end
                        else   // Somente exibir mensagem na tela e fazer nova consulta
                           begin
                              //------------------------------------------------
                              //   Fazer nova consulta
                              //------------------------------------------------
                              frmwebtef.mensagem := 'CONSULTANDO TEF';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                              SA_SalvarLog('CONSULTAR:',payload.ToString);   // Salvar LOG
                              //------------------------------------------------
                              resultado :=  UTF8ToString(RealizarAdmTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                              SA_SalvarLog('Resposta CONSULTAR:',resultado);   // Salvar LOG
                              RespConsTEF  := SA_ParsingTEF(resultado);
                              sair := false;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        if (RespConsTEF.automacao_coleta_retorno<>'0') and (not sair) then
                           begin
                              //------------------------------------------------
                              if (RespConsTEF.retorno='0') or (RespConsTEF.retorno='1') then
                                 begin
                                    //------------------------------------------
                                    //   Verificar se h� impressos a serem executados
                                    //------------------------------------------
                                    if RespConsTEF.comprovanteDiferenciadoLoja<>'' then
                                       begin
                                          if LComprovanteLoja<>tpiNaoImprimir then
                                             begin
                                                TpComprovanteImprimir            := tpLoja;
                                                comprovanteDiferenciadoLoja      := TStringList.Create;
                                                comprovanteDiferenciadoLoja.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                                SA_ImprimirComprovante(comprovanteDiferenciadoLoja,'Imprimir comprovante da loja ?');
                                                comprovanteDiferenciadoLoja.Free;
                                             end;
                                       end;
                                    if RespConsTEF.comprovanteDiferenciadoPortador<>'' then
                                       begin
                                          if LComprovanteCliente<>tpiNaoImprimir then
                                             begin
                                                TpComprovanteImprimir                := tpCliente;
                                                comprovanteDiferenciadoPortador      := TStringList.Create;
                                                comprovanteDiferenciadoPortador.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                                SA_ImprimirComprovante(comprovanteDiferenciadoPortador,'Imprimir comprovante do cliente ?');
                                                comprovanteDiferenciadoPortador.Free;
                                             end;
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.mensagem := 'Finalizando conex�o...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a opera��o de TEF
                              SA_SalvarLog('Resposta FINALIZAR:',resultado);   // Salvar LOG
                              //------------------------------------------------
                              if RespConsTEF.mensagemResultado<>'' then
                                 frmwebtef.mensagem := RespConsTEF.mensagemResultado
                              else
                                 frmwebtef.mensagem := 'Ocorreu um erro na opera��o !';
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              sair := true;
                              frmwebtef.Cancelar := false;
                              while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                 begin
                                    sleep(50);
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                        //******************************************************
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------
end;



procedure TElginTEF.SA_Configurar_TEF;
begin
  SetClientTCP(pansichar(ansistring('127.0.0.1')), 60906);
  ConfigurarDadosPDV(pansichar(ansistring(TEFTextoPinPad)), pansichar(ansistring('ACMKM')), pansichar(ansistring('Automacao Comercial')), pansichar(ansistring('999999999')), pansichar(ansistring('999999999')));
end;

procedure TElginTEF.SA_CriarMenuT;
begin
   SA_Criar_Menu(true);
end;

procedure TElginTEF.SA_DesativarBtCancelarT;
begin
   SA_DesativarBTCancelar;
end;

procedure TElginTEF.SA_DesativarMenuT;
begin
   SA_Criar_Menu(false);
end;

function TElginTEF.SA_GerarComprovanteSimplificado: TStringList;
begin
   Result := TStringList.Create;
   Result.Add('</ce>COMPROVANTE TEF - Via Lojista');
   Result.Add('</ae>');
   Result.Add('   Realizada em   '+LdataHoraTransacao);
   Result.Add('       Valor R$   '+transform(LValor));
   Result.Add('     Forma Pgto   '+LForma);
   Result.Add('            NSU   '+LNSU);
   Result.Add('        Cod.Aut.  '+LcAut);
   Result.Add('       Bandeira   '+LtBand);
end;

procedure TElginTEF.SA_ImprimirComprovante(comprovante: TStringList;  pergunta: string);
var
   sair          : boolean;
   tipoimpressao : TtpImpressao;
begin
   tipoimpressao := tpiPerguntar;
   case TpComprovanteImprimir of
      tpLoja    : tipoimpressao := LComprovanteLoja;
      tpCliente : tipoimpressao := LComprovanteCliente;
   end;
   //---------------------------------------------------------------------------
   if tipoimpressao=tpiPerguntar then
      begin
         frmwebtef.mensagem := pergunta;
         frmwebtef.opcoes   := TStringList.Create;
         frmwebtef.opcoes.Add('Imprimir');
         frmwebtef.opcoes.Add('N�o imprimir');
         frmwebtef.tecla    := '';
         frmwebtef.opcao    := 0;
         frmwebtef.Cancelar := false;
         SA_Criar_Menu(true);
         sair := false;
         while not sair do
            begin
               //---------------------------------------------------------------
               if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                  begin
                     //---------------------------------------------------------
                     //   Executar a impress�o
                     //---------------------------------------------------------
                     if LImpressaoReduzida then
                        GerenciadorImpressao.Corpo := SA_ResumirComprovante(comprovante)
                     else
                        GerenciadorImpressao.Corpo.Text  := comprovante.Text;
                     GerenciadorImpressao.SA_Imprimir(1);
                     sair := true;
                     //---------------------------------------------------------
                  end
               else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                  sair := true;
               if frmwebtef.Cancelar then
                  sair := true;
               //---------------------------------------------------------------
               sleep(30);
               //---------------------------------------------------------------
            end;
         //---------------------------------------------------------------------
         SA_Criar_Menu(false);
         //---------------------------------------------------------------------
      end
   else if tipoimpressao=tpiImprimir then
      begin
         //---------------------------------------------------------------------
         //   Executar a impress�o
         //---------------------------------------------------------------------
         if LImpressaoReduzida then
            GerenciadorImpressao.Corpo  := SA_ResumirComprovante(comprovante)
         else
            GerenciadorImpressao.Corpo.Text  := comprovante.Text;
         GerenciadorImpressao.SA_Imprimir(1);
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
end;

procedure TElginTEF.SA_Inicializar_ESCPOS;
var
   linhas_escpos : TStringList;
   d             : integer;
begin
   //---------------------------------------------------------------------------
   //---------------------------------------------------------------------------
   GerenciadorImpressao                      := TESCPos.Create;
   GerenciadorImpressao.PortaImpressora      := LPortaImpressora;
   GerenciadorImpressao.ImprimirCabecalho    := true;
   GerenciadorImpressao.Avanco               := lavanco;
   GerenciadorImpressao.ModeloImpressoraACBR := LModeloImpressoraACBR;
   //---------------------------------------------------------------------------
   GerenciadorImpressao.ImpressoraPOSPrinter.PaginaDeCodigo := LPaginaDeCodigo;
   GerenciadorImpressao.Cabecalho.Text := '';
   //---------------------------------------------------------------------------
   linhas_escpos := TStringList.Create;
   linhas_escpos.Add(StringOfChar('=',GerenciadorImpressao.MLNormal));
   linhas_escpos.Add('');
   for d := 1 to GerenciadorImpressao.Avanco do
      linhas_escpos.Add('');
   linhas_escpos.Add(GerenciadorImpressao.MGuilhotina);
   GerenciadorImpressao.Rodape.Text := linhas_escpos.Text;
   linhas_escpos.Free;
   //---------------------------------------------------------------------------

end;

function TElginTEF.SA_Inicializar_TEF: boolean;
var
   payload   : TJsonObject;
   resultado : string;
   RespJSON  : TJSONValue;
   RespTEF   : TJSONValue;
   codigoTEF : integer;
begin
   //---------------------------------------------------------------------------
   payload   := TJsonObject.Create;
   //---------------------------------------------------------------------------
   payload.AddPair('aplicacao','ACMKM');
   payload.AddPair('aplicacao_tela','ACMKM');
   payload.AddPair('versao','45x');
   payload.AddPair('estabelecimento','Automacao Comercial');
   payload.AddPair('loja','999999999');
   payload.AddPair('terminal','01');
   payload.AddPair('nomeAC','ACMKM');
   payload.AddPair('textoPinpad',LTEFTextoPinPad);
   payload.AddPair('versaoAC','45x');
   payload.AddPair('nomeEstabelecimento','Automacao Comercial');
   payload.AddPair('identificadorPontoCaptura','999999999');
   //---------------------------------------------------------------------------
   SA_SalvarLog('INICIALIZAR',payload.ToString);

   resultado := UTF8ToString(IniciarOperacaoTEF(PAnsiChar(AnsiString(payload.ToString))));
   RespJSON  := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( resultado ),0) as TJSONValue;
   payload.Free;
   SA_SalvarLog('INICIALIZAR Resposta',resultado);
   codigoTEF := 0;
   try
      codigoTEF := RespJSON.GetValue<integer>('codigo',0);
   except
   end;
   //---------------------------------------------------------------------------
   try
      RespTEF     := RespJSON.GetValue<TJSONObject>('tef');      // Parsing na resposta
      Result      := (RespTEF.GetValue<string>('retorno','') = '1') and (codigoTEF=0);  // Pegando o resultado da opera��o
      LSequencial := RespTEF.GetValue<integer>('sequencial',0);  // Pegando o numero sequencial para gerir as opera��es
      RespTEF.Free;
   except
      Result      := false;
      LSequencial := 0;
   end;
   //---------------------------------------------------------------------------
end;

function TElginTEF.SA_Limpacampo(campo: string): string;
var
   d     : integer;
begin
   Result := '';
   for d:=1 to length(campo) do
      begin
         if CharInSet(campo[d],['0'..'9']) then
            Result := Result + campo[d];
      end;
end;

procedure TElginTEF.SA_MostramensagemT;
begin
   SA_Mostrar_Mensagem(true);
end;

procedure TElginTEF.SA_MostrarBtCancelarT;
begin
   SA_AtivarBTCancelar;   // Ativar o bot�o cancelar na tela de TEF
end;

function TElginTEF.SA_Opcoes(opcoes: string): TStringList;
var
   palavra : string;
begin
   Result := TStringList.Create;
   while pos(';',opcoes)>0 do
      begin
         palavra := copy(opcoes,1,pos(';',opcoes)-1);
         Delete(opcoes,1,length(palavra)+1);
         Result.Add(palavra);
      end;
   if opcoes<>'' then
      Result.Add(opcoes);
end;
//------------------------------------------------------------------------------
//   Processar PIX
//------------------------------------------------------------------------------
procedure TElginTEF.SA_PagamentoPIX;
var
   inicializar  : boolean;
   sair         : boolean;
   resultado    : string;
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transa��o
   RespReqTEF   : TTefRetorno; // Retorno da requisi��o inicial de pagamento
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   //---------------------------------------------------------------------------
   opcoesColeta : TStringList;
   opcaoColeta  : integer;
   DadoColeta   : string;   // Dado obtido do operador para a coleta
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Pagamento com  PIX
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //  Iniciando THREAD para processar o PIX
      //   Inicializar TEF
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      inicializar := SA_Inicializar_TEF;
      //------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('Resposta FINALIZAR:',resultado);
            frmwebtef.mensagem := 'Erro na inicializa��o do TEF';
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do
               begin
                  sleep(30);
               end;
            //------------------------------------------------------------------
            lExecutando := false;
            frmwebtef.Close;
            frmwebtef.Release;
            //------------------------------------------------------------------
            exit;
         end;
      //------------------------------------------------------------------------
      inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada � DLL
      payload := TJsonObject.Create;
      payload.AddPair('sequencial', LSequencial.ToString);
      payload.AddPair('valorTotal', SA_Limpacampo(transform(LValor)));
      //------------------------------------------------------------------------
      frmwebtef.mensagem := 'Solicitando pagamento...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //------------------------------------------------------------------------
      SA_SalvarLog('VENDER:',payload.ToString);
      resultado   := UTF8ToString(RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), true));
      SA_SalvarLog('Resposta VENDER:',resultado);
      //------------------------------------------------------------------------
      RespReqTEF  := SA_ParsingTEF(resultado);
      //------------------------------------------------------------------------
      sair := false;
      while not sair do   // Fazendo o fluxo do TEF
         begin
            //------------------------------------------------------------------
            if RespReqTEF.retorno='' then  // N�o houve retorno do TEF
               begin
                  //------------------------------------------------------------
                  if (RespReqTEF.automacao_coleta_retorno<>'0') then
                     begin
                        //------------------------------------------------------
                        //  Mostrar mensagem, finalizar TEF e sair da rotina
                        //------------------------------------------------------
                        frmwebtef.mensagem := RespReqTEF.mensagemResultado;
                        TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                        //------------------------------------------------------
                        resultado := UTF8ToString(FinalizarOperacaoTEF(1));
                        SA_SalvarLog('Resposta FINALIZAR:',resultado);
                        //------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                        //------------------------------------------------------
                        while not frmwebtef.Cancelar do
                           begin
                              sleep(10);
                           end;
                        //------------------------------------------------------
                        sair := true;
                        //------------------------------------------------------
                     end
                  else if RespReqTEF.automacao_coleta_retorno='0' then
                     begin
                        //------------------------------------------------------
                        //   Examinar TEF
                        //------------------------------------------------------
                        if (RespReqTEF.automacao_coleta_tipo='') then  // Tem que consultar
                           begin
                              //------------------------------------------------
                              //   Apresentar mensagem
                              //------------------------------------------------
                              if not pos('QRCODE;',RespReqTEF.mensagemResultado)=0 then  // N�o � o QRCODE PIX imagem
                                 begin
                                    frmwebtef.mensagem := RespReqTEF.mensagemResultado;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end
                              else   // � QRCODE
                                 begin
                                    frmwebtef.mensagem := 'Fa�a a leitura do QRCODE no PINPAD ...';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                 end;
                              //------------------------------------------------
                              //  Consultar TEF
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_retorno',RespReqTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_sequencial',RespReqTEF.automacao_coleta_sequencial);
                              //------------------------------------------------
                              SA_SalvarLog('CONSULTA PIX:',payload.ToString);
                              //------------------------------------------------
                              resultado   := UTF8ToString( RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), false));
                              //------------------------------------------------
                              SA_SalvarLog('Resposta CONSULTA PIX:',resultado);
                              //------------------------------------------------
                              RespReqTEF  := SA_ParsingTEF(resultado);
                              //------------------------------------------------
                           end
                        else if (RespReqTEF.automacao_coleta_tipo<>'') and (RespReqTEF.automacao_coleta_opcao<>'') then  // Tem que consultar
                           begin
                              //------------------------------------------------
                              //  Criar menu de op��es
                              //------------------------------------------------
                               opcoesColeta := SA_Opcoes(RespReqTEF.automacao_coleta_opcao);
                               //---------------------------------------------------
                               frmwebtef.mensagem := RespReqTEF.mensagemResultado;
                               frmwebtef.opcoes   := opcoesColeta;
                               frmwebtef.opcao    := -1;
                               frmwebtef.tecla    := '';
                               frmwebtef.Cancelar := false;
                               //---------------------------------------------------
                               TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                               TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                               //---------------------------------------------------
                               opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespReqTEF.mensagemResultado);   // Apanhando a op��o do menu
                               if opcaoColeta<>-1 then
                                  DadoColeta   := opcoesColeta[opcaoColeta-1]  // Obtendo dado para a coleta
                               else
                                  DadoColeta   := '';   // Definindo o valor vazio para coleta
                               //---------------------------------------------------
                               TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                               TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                               if DadoColeta<>'' then   // Tem que enviar a resposta
                                  begin
                                     //------------------------------------------
                                     //  Enviara a requisi��o
                                     //------------------------------------------
                                     payload := TJsonObject.Create;
                                     payload.AddPair('automacao_coleta_retorno', RespReqTEF.automacao_coleta_retorno);
                                     payload.AddPair('automacao_coleta_sequencial', RespReqTEF.automacao_coleta_sequencial);
                                     payload.AddPair('automacao_coleta_informacao', DadoColeta);
                                     //------------------------------------------
                                     SA_SalvarLog('EVIAR TIPO PIX:',payload.ToString);
                                     //------------------------------------------
                                     resultado   := UTF8ToString( RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), false));
                                     //------------------------------------------
                                     SA_SalvarLog('Resposta EVIAR TIPO PIX:',resultado);
                                     //------------------------------------------
                                     RespReqTEF  := SA_ParsingTEF(resultado);
                                     //------------------------------------------
                                  end
                               else
                                  begin
                                     //------------------------------------------
                                     //  Cancelar a opera��o
                                     //------------------------------------------
                                     payload := TJsonObject.Create;
                                     payload.AddPair('automacao_coleta_retorno', '9');
                                     //------------------------------------------
                                     SA_SalvarLog('CANCELAR PIX:',payload.ToString);
                                     //------------------------------------------
                                     resultado   := UTF8ToString( RealizarPixTEF(PAnsiChar(AnsiString(payload.ToString)), false));
                                     //------------------------------------------
                                     SA_SalvarLog('Resposta CANCELAR PIX:',resultado);
                                     //------------------------------------------
                                     resultado := UTF8ToString(FinalizarOperacaoTEF(1));
                                     //------------------------------------------
                                     RespReqTEF  := SA_ParsingTEF(resultado);
                                     SA_SalvarLog('Resposta FINALIZAR:',resultado);
                                     //------------------------------------------
                                  end;
                               //------------------------------------------------
                            end;
                        //------------------------------------------------------
                     end;

                  //------------------------------------------------------------
               end
            else if RespReqTEF.retorno='0' then   // Houve resposta da transa��o
               begin
                  //------------------------------------------------------------
                  //   Processar o retorno do TEF PIX
                  //   Capturar os dados da transa��o em BD
                  //------------------------------------------------------------
                  LNSU              := RespReqTEF.nsuTerminal;
                  LNome_do_Produto  := RespReqTEF.tipoCartao;
                  LcAut             := RespReqTEF.codigoAutorizacao;
                  Lrede             := RespReqTEF.nomeProvedor;
                  LtBand            := RespReqTEF.nomeBandeira;
                  LCNPJAdquirente   := RespReqTEF.cnpjCredenciadora;
                  //------------------------------------------------------------
                  resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,1));  // Confirmar opera��o
                  //------------------------------------------------------------
                  SA_SalvarLog('Resposta CONFIRMAR:',resultado);
                  //------------------------------------------------------------
                  resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transa��o
                  //------------------------------------------------------------
                  SA_SalvarLog('Resposta FINALIZAR:',resultado);
                  //------------------------------------------------------------
                  //   TEF confirmado
                  //------------------------------------------------------------
                  if RespReqTEF.comprovanteDiferenciadoLoja<>'' then
                     begin
                        if LComprovanteLoja<>tpiNaoImprimir then
                           begin
                              TpComprovanteImprimir            := tpLoja;
                              comprovanteDiferenciadoLoja      := TStringList.Create;
                              comprovanteDiferenciadoLoja.Text := StringReplace(RespReqTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                              if LComprovanteLoja=tpiImprimir then
                                 begin
                                    GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoLoja.Text;
                                    GerenciadorImpressao.SA_Imprimir(1);
                                 end
                              else if LComprovanteLoja=tpiPerguntar then
                                 begin
                                    //------------------------------------------
                                    //   Perguntar se quer imprimir
                                    //------------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('N�o Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    //-----------------------------------------
                                    while (not frmwebtef.Cancelar) do
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               //------------------------------
                                               //   Executar a impress�o
                                               //------------------------------
                                               GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoLoja.Text;
                                               GerenciadorImpressao.SA_Imprimir(1);
                                               frmwebtef.Cancelar := true;
                                               //------------------------------
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                            frmwebtef.Cancelar := true;
                                          //-----------------------------------
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end;
                              comprovanteDiferenciadoLoja.Free;
                           end;
                     end;
                  if RespReqTEF.comprovanteDiferenciadoPortador<>'' then
                     begin
                        if LComprovanteCliente<>tpiNaoImprimir then
                           begin
                              TpComprovanteImprimir                := tpCliente;
                              comprovanteDiferenciadoPortador      := TStringList.Create;
                              comprovanteDiferenciadoPortador.Text := StringReplace(RespReqTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                              if LComprovanteCliente=tpiImprimir then
                                 begin
                                    //------------------------------------------
                                    //  Imprimir autom�tico
                                    //------------------------------------------
                                    GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoPortador.Text;
                                    GerenciadorImpressao.SA_Imprimir(1);
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    //------------------------------------------
                                    //  Criar menu de imprimir
                                    //------------------------------------------
                                    opcoesColeta := TStringList.Create;
                                    opcoesColeta.Add('Imprimir');
                                    opcoesColeta.Add('N�o Imprimir');
                                    frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                    frmwebtef.opcoes   := opcoesColeta;
                                    frmwebtef.opcao    := -1;
                                    frmwebtef.tecla    := '';
                                    frmwebtef.Cancelar := false;
                                    //------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                    //-----------------------------------------
                                    while (not frmwebtef.Cancelar) do
                                       begin
                                         if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                            begin
                                               //------------------------------
                                               //   Executar a impress�o
                                               //------------------------------
                                               GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoPortador.Text;
                                               GerenciadorImpressao.SA_Imprimir(1);
                                               frmwebtef.Cancelar := true;
                                               //------------------------------
                                            end
                                         else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                            frmwebtef.Cancelar := true;
                                          //-----------------------------------
                                          sleep(50);
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //------------------------------------------
                                 end;   
                              comprovanteDiferenciadoPortador.Free;
                           end;
                     end;
                  //------------------------------------------------------------
                  sair := true;
                  //------------------------------------------------------------                  
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //---------------------------------------------------------------------------

   end).Start;
   //---------------------------------------------------------------------------
end;

function TElginTEF.SA_ParsingTEF(conteudo: string): TTefRetorno;
var
   JSONConteudo : TJSONValue;
   JSONTef      : TJSONValue;
   MensagemOP   : string;
begin
   //---------------------------------------------------------------------------
   try
      JSONConteudo := TJSonObject.ParseJSONValue(TEncoding.UTF8.GetBytes( conteudo ),0) as TJSONValue;
   except
      exit;
   end;
   //---------------------------------------------------------------------------
   try
      MensagemOP               := JSONConteudo.GetValue<string>('mensagem','');
      Result.retorno           := inttostr(JSONConteudo.GetValue<integer>('codigo',9));
      Result.codigo            := strtointdef(Result.retorno,0);
      Result.mensagemResultado := JSONConteudo.GetValue<string>('mensagem','');
   except
   end;
   //---------------------------------------------------------------------------
   try
      JSONTef      := JSONConteudo.GetValue<TJSONObject>('tef',nil);
   except
      exit;
   end;
   //---------------------------------------------------------------------------
   if JSONTef=nil then
      exit;
   //---------------------------------------------------------------------------
   Result.linhasMensagemRetorno           := TStringList.Create;
   Result.automacao_coleta_opcao          := JSONTef.GetValue<string>('automacao_coleta_opcao','');
   Result.automacao_coleta_palavra_chave  := JSONTef.GetValue<string>('automacao_coleta_palavra_chave','');
   Result.automacao_coleta_retorno        := JSONTef.GetValue<string>('automacao_coleta_retorno','');
   Result.automacao_coleta_sequencial     := JSONTef.GetValue<string>('automacao_coleta_sequencial','');
   Result.automacao_coleta_tipo           := JSONTef.GetValue<string>('automacao_coleta_tipo','');
   Result.automacao_coleta_mascara        := JSONTef.GetValue<string>('automacao_coleta_mascara','');
   Result.mensagemResultado               := JSONTef.GetValue<string>('mensagemResultado','');
   Result.cnpjCredenciadora               := JSONTef.GetValue<string>('cnpjCredenciadora','');
   Result.codigoAutorizacao               := JSONTef.GetValue<string>('codigoAutorizacao','');
   Result.comprovanteDiferenciadoLoja     := JSONTef.GetValue<string>('comprovanteDiferenciadoLoja','');
   Result.comprovanteDiferenciadoPortador := JSONTef.GetValue<string>('comprovanteDiferenciadoPortador','');
   Result.dataHoraTransacao               := JSONTef.GetValue<string>('dataHoraTransacao','');
   Result.formaPagamento                  := JSONTef.GetValue<string>('formaPagamento','');
   Result.identificadorEstabelecimento    := JSONTef.GetValue<string>('identificadorEstabelecimento','');
   Result.identificadorPontoCaptura       := JSONTef.GetValue<string>('identificadorPontoCaptura','');
   Result.loja                            := JSONTef.GetValue<string>('loja','');
   Result.nomeBandeira                    := JSONTef.GetValue<string>('nomeBandeira','');
   Result.nomeEstabelecimento             := JSONTef.GetValue<string>('nomeEstabelecimento','');
   Result.nomeProduto                     := JSONTef.GetValue<string>('nomeProduto','');
   Result.nomeProvedor                    := JSONTef.GetValue<string>('nomeProvedor','');
   Result.nsuTerminal                     := JSONTef.GetValue<string>('nsuTerminal','');
   Result.nsuTransacao                    := JSONTef.GetValue<string>('nsuTransacao','');
   Result.panMascarado                    := JSONTef.GetValue<string>('panMascarado','');
   Result.resultadoTransacao              := JSONTef.GetValue<string>('resultadoTransacao','');
   Result.retorno                         := JSONTef.GetValue<string>('retorno','');
   Result.sequencial                      := JSONTef.GetValue<string>('sequencial','');
   Result.servico                         := JSONTef.GetValue<string>('servico','');
   Result.tipoCartao                      := JSONTef.GetValue<string>('tipoCartao','');
   Result.transacao                       := JSONTef.GetValue<string>('transacao','');
   Result.uniqueID                        := JSONTef.GetValue<string>('uniqueID','');
   Result.valorTotal                      := JSONTef.GetValue<string>('valorTotal','');
   Result.linhasMensagemRetorno           := SA_RecuperarLinhasMensagem(Result.mensagemResultado);
   //---------------------------------------------------------------------------
   JSONConteudo.Free;
   //---------------------------------------------------------------------------
end;

function TElginTEF.SA_PerguntarOpcoes(opcoes: TStringList;mensagem:string): integer;
var
   sair : boolean;
begin
   Result             := -1;
   frmwebtef.opcao    := 0;
   frmwebtef.tecla    := '';
   frmwebtef.Cancelar := false;
   sair               := false;
   while not sair do
      begin
         //---------------------------------------------------------------------
         if frmwebtef.Cancelar then
            begin
               Result := -1;
               sair := true;
            end;

         if (frmwebtef.opcao<>0) then
            begin
               Result := frmwebtef.opcao;
               sair   := true;
            end;

         if (strtointdef(frmwebtef.tecla,256)<=opcoes.Count) and (strtointdef(frmwebtef.tecla,256)<>0) then
           begin
              Result := strtointdef(frmwebtef.tecla,-1);
              sair   := true;
           end;

         //---------------------------------------------------------------------
         if not sair then
            sleep(50);
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

procedure TElginTEF.SA_ProcessarPagamento;
var
   inicializar  : boolean;
   resultado    : string;
   payload      : TJsonObject; // Objeto JSON para armazenar os dados da transa��o
   RespReqTEF   : TTefRetorno; // Retorno da requisi��o inicial de pagamento
   RespConsTEF  : TTefRetorno; // Retorno da requisi��o inicial de pagamento
   retorno      : string;
   sair         : boolean;
   //---------------------------------------------------------------------------
   comprovanteDiferenciadoLoja     : TStringList;
   comprovanteDiferenciadoPortador : TStringList;
   FormaPgtoPAYLOAD                : string;
   tpFinPAYLOAD                    : string;
   //---------------------------------------------------------------------------
   opcoesColeta : TStringList;
   opcaoColeta  : integer;
   //---------------------------------------------------------------------------
   Consultar_TEF : boolean;
   //---------------------------------------------------------------------------
   Qtde_Parcelas : string;

begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TipoTef          := tpTEFELGIN;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //---------------------------------------------------------------------------
      //   Inicializar TEF
      //---------------------------------------------------------------------------
      frmwebtef.mensagem := 'Inicializando TEF...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //---------------------------------------------------------------------------
      inicializar := SA_Inicializar_TEF;
      //---------------------------------------------------------------------------
      if not inicializar then
         begin
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));
            SA_SalvarLog('FINALIZAR:',resultado);
            frmwebtef.mensagem := 'Erro na inicializa��o do TEF';
            //---------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //---------------------------------------------------------------------
            lExecutando := false;
            frmwebtef.Close;
            frmwebtef.Release;
            //---------------------------------------------------------------------
            exit;
         end;
      //---------------------------------------------------------------------------
      ///   Processar o pagamento
      //---------------------------------------------------------------------------
      case LFormaPgto of   // Tipo de pagamento
         tpFormaVista     : FormaPgtoPAYLOAD := 'A vista';
         tpFormaParcelado : FormaPgtoPAYLOAD := 'Parcelado';
         tpFormaPerguntar : FormaPgtoPAYLOAD := '';
         tpFormaPreDatado : FormaPgtoPAYLOAD := 'Pre-datado';
      end;

      case LtpFinanciamento of
        tpFinPerguntar      : tpFinPAYLOAD :='';
        tpFinLojista        : tpFinPAYLOAD :='Estabelecimento';
        tpFinAdministradora : tpFinPAYLOAD :='Administradora';
      end;

      inc(LSequencial);   // Incrementando o numero sequencial para realizar a chamada � DLL
      payload := TJsonObject.Create;
      payload.AddPair('sequencial', LSequencial.ToString);
      payload.AddPair('valorTotal', SA_Limpacampo(transform(LValor)));
      if FormaPgtoPAYLOAD<>'' then
         payload.AddPair('formaPagamento', FormaPgtoPAYLOAD);
      if tpFinPAYLOAD<>'' then
         payload.AddPair('tipoFinanciamento', tpFinPAYLOAD);
      if LQtdeParcelas>0 then
         payload.AddPair('transacao_parcela', LQtdeParcelas.ToString);
      //---------------------------------------------------------------------------
      frmwebtef.mensagem := 'Solicitando pagamento...';
      TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
      //---------------------------------------------------------------------------
      SA_SalvarLog('VENDER:',payload.ToString);
      resultado   := UTF8ToString(RealizarPagamentoTEF( SA_TpCartaoOperacaoTEFtoINT(LTpCartaoOperacaoTEF) , PAnsiChar(AnsiString(payload.ToString)), True));
      SA_SalvarLog('Resposta VENDER',resultado);
      RespReqTEF  := SA_ParsingTEF(resultado);
      retorno     := RespReqTEF.retorno;  // Pegar o retorno
      //---------------------------------------------------------------------------
      if ((strtointdef(retorno,0)>=1) and (strtointdef(retorno,0)<=8)) or (retorno='-1') then   // Ocorreu um erro que exige a finaliza��o da opera��o
         begin
            //---------------------------------------------------------------------
            //   Mostrar a mensagem de erro na tela
            //---------------------------------------------------------------------
            SA_SalvarLog('FINALIZAR TEF:','Finalizando a transa��o');   // Salvar LOG
            resultado := UTF8ToString(FinalizarOperacaoTEF(1)); // Finalizando a opera��o de TEF
            SA_SalvarLog('Resposta FINALIZAR TEF:',resultado);   // Salvar LOG
            if RespReqTEF.mensagemResultado<>'' then   // Se o TEF mandou exibir alguma mensagem
               frmwebtef.mensagem := RespReqTEF.mensagemResultado
            else   // Sem mensagem nenhuma, criando uma padr�o
               frmwebtef.mensagem := 'Ocorreu erro na requisi��o de pagamento...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
               begin
                  sleep(50);
               end;
            //---------------------------------------------------------------------
         end
      else if strtointdef(retorno,0)=9 then   // Ocorreu um erro que requer o cancelamento da opera��o
         begin
            //---------------------------------------------------------------------
            //  Mostrar a mensagem do TEF na tela
            //---------------------------------------------------------------------
            if RespReqTEF.mensagemResultado<>'' then   // Se o TEF mandou exibir alguma mensagem
               frmwebtef.mensagem := RespReqTEF.mensagemResultado
            else   // Sem mensagem nenhuma, criando uma padr�o
               frmwebtef.mensagem := 'Ocorreu erro na requisi��o de pagamento...';
            TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
            //---------------------------------------------------------------------
            payload := TJsonObject.Create;
            payload.AddPair('sequencial', LSequencial.ToString);  // Executando o cancelamento
            payload.AddPair('automacao_coleta_retorno', '9');
            //---------------------------------------------------------------------
            SA_SalvarLog('CANCELAR:',payload.ToString);
            //---------------------------------------------------------------------
            resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
            //---------------------------------------------------------------------
            SA_SalvarLog('Resposta CANCELAR:',resultado);
            //---------------------------------------------------------------------
            resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transa��o
            SA_SalvarLog('Resposta FINALIZAR:',resultado);
            //---------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
            while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
               begin
                  sleep(50);
               end;
            //---------------------------------------------------------------------
         end
      else if strtointdef(retorno,0)=0 then   //   � necess�rio ficar monitorando e fazer coleta
         begin
            //---------------------------------------------------------------------
            RespConsTEF         := RespReqTEF;
            RespConsTEF.retorno := '';
            //---------------------------------------------------------------------
            //   Fazendo LOOP de consulta no TEF
            //---------------------------------------------------------------------
            sair               := false;
            frmwebtef.tecla    := '';
            frmwebtef.Cancelar := false;
            Consultar_TEF      := true;
            while not sair do
               begin
                  //---------------------------------------------------------------
                  if RespConsTEF.retorno='' then  // � pra continuar fazendo leitura
                     begin
                        //---------------------------------------------------------
                        if RespConsTEF.automacao_coleta_tipo='N' then   // Tem que digitar um valor num�rico
                           begin
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                  begin
                                     SA_ColetarValor(RespConsTEF.mensagemResultado,'',false);
                                  end);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              frmwebtef.AceitaVazio   := true;
                              Qtde_Parcelas           := '';
                              while (Qtde_Parcelas='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (strtointdef(frmwebtef.dado_digitado,0)>=2) and (strtointdef(frmwebtef.dado_digitado,0)<=99) or (length(frmwebtef.dado_digitado)>2)  then
                                       Qtde_Parcelas := frmwebtef.dado_digitado
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inv�lido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              if Qtde_Parcelas='&*&' then
                                 Qtde_Parcelas := '';
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              if not frmwebtef.Cancelar then
                                 begin
                                    frmwebtef.mensagem := 'Enviando dados ao TEF';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //---------------------------------------------
                                    SA_SalvarLog('COLETA:','{"automacao_coleta_sequencial":"'+RespConsTEF.automacao_coleta_sequencial+'","automacao_coleta_retorno":"'+RespConsTEF.automacao_coleta_retorno+'","automacao_coleta_informacao":"'+Qtde_Parcelas+'"}');
                                    //---------------------------------------------
                                    resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString('{"automacao_coleta_sequencial":"'+RespConsTEF.automacao_coleta_sequencial+'","automacao_coleta_retorno":"'+RespConsTEF.automacao_coleta_retorno+'","automacao_coleta_informacao":"'+Qtde_Parcelas+'"}')), false));
                                    //---------------------------------------------
                                    SA_SalvarLog('Resposta COLETA:',resultado);
                                    //---------------------------------------------
                                    RespconsTEF   := SA_ParsingTEF(resultado);
                                    Consultar_TEF := false;
                                    //---------------------------------------------
                                    frmwebtef.mensagem := RespconsTEF.mensagemResultado;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao<>'') then // Criar menu de op��es string
                           begin
                              //----------------------------------------------------
                              //    Fazer a coleta das op��es
                              //----------------------------------------------------
                              opcoesColeta := SA_Opcoes(RespConsTEF.automacao_coleta_opcao);
                              //----------------------------------------------------
                              frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                              frmwebtef.opcoes   := opcoesColeta;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //----------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                              //----------------------------------------------------
                              application.ProcessMessages;
                              opcaoColeta  := SA_PerguntarOpcoes(opcoesColeta,RespConsTEF.mensagemResultado);
                              //----------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    SA_Criar_Menu(false);
                                 end);
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //---------------------------------------------------
                              if opcaoColeta<>-1 then
                                 begin
                                    //----------------------------------------------
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_informacao', opcoesColeta[opcaoColeta-1]);
                                    //----------------------------------------------
                                    SA_SalvarLog('COLETA:',payload.ToString);
                                    //----------------------------------------------
                                    resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    //----------------------------------------------
                                    SA_SalvarLog('Resposta COLETA:',resultado);
                                    //----------------------------------------------
                                    RespconsTEF  := SA_ParsingTEF(resultado);
                                    Consultar_TEF := false;
                                    //----------------------------------------------
                                 end;
                              opcoesColeta.Free;
                              //-----------------------------------------------------
                           end
                        else if (RespConsTEF.automacao_coleta_tipo='X') and (RespConsTEF.automacao_coleta_opcao='') then // Coletar informa��o string do teclado
                           begin
                              //------------------------------------------------
                              // Criar uma tela para digitar os dados
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              TThread.Synchronize(TThread.CurrentThread,
                              procedure
                                 begin
                                    frmwebtef.AceitaVazio := false;
                                    SA_ColetarValor(RespConsTEF.mensagemResultado,'',RespConsTEF.automacao_coleta_palavra_chave='transacao_administracao_senha');
                                 end);
                              //------------------------------------------------
                              Qtde_Parcelas           := '';
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              while (frmwebtef.dado_digitado='') and(not frmwebtef.Cancelar) do
                                 begin
                                    sleep(10);
                                 end;
                              Qtde_Parcelas   := frmwebtef.dado_digitado;
                              frmwebtef.pncaptura.Visible := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //------------------------------------------------
                              payload := TJsonObject.Create;
                              payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                              payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                              payload.AddPair('automacao_coleta_informacao', Qtde_Parcelas);
                              //------------------------------------------------
                              SA_SalvarLog('COLETA:',payload.ToString);
                              //------------------------------------------------
                              resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                              //------------------------------------------------
                              SA_SalvarLog('Resposta COLETA:',resultado);
                              //------------------------------------------------
                              RespconsTEF  := SA_ParsingTEF(resultado);
                              Consultar_TEF := false;
                              //------------------------------------------------
                              frmwebtef.mensagem := RespconsTEF.mensagemResultado;
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              //------------------------------------------------
                           end
                        else if RespConsTEF.automacao_coleta_tipo='D' then // Coletar informa��o DATA do teclado
                           begin
                              //----------------------------------------------------
                              //   Coletar Data do operador
                              //----------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    frmwebtef.AceitaVazio := false;
                                    SA_ColetarValor(RespConsTEF.mensagemResultado,'99/99/9999',false);
                                 end);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              frmwebtef.CaracteresDigitaveis := ['0'..'9',#8];
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              Qtde_Parcelas           := '';
                              while (Qtde_Parcelas='') and (not frmwebtef.Cancelar) do
                                 begin
                                    //---------------------------------------------
                                    sleep(10);
                                    //---------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (vale(frmwebtef.dado_digitado)) then
                                       Qtde_Parcelas := frmwebtef.dado_digitado
                                    else if (frmwebtef.dado_digitado<>'') then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inv�lido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //---------------------------------------------------
                              if vale(Qtde_Parcelas) then
                                 begin
                                    frmwebtef.mensagem := 'Enviando dados ao TEF';
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    payload := TJsonObject.Create;
                                    payload.AddPair('automacao_coleta_sequencial', RespConsTEF.automacao_coleta_sequencial);
                                    payload.AddPair('automacao_coleta_retorno', RespConsTEF.automacao_coleta_retorno);
                                    payload.AddPair('automacao_coleta_informacao', Qtde_Parcelas);
                                    //---------------------------------------------
                                    SA_SalvarLog('COLETA:',payload.ToString);
                                    //---------------------------------------------
                                    resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                                    //---------------------------------------------
                                    SA_SalvarLog('Resposta COLETA:',resultado);
                                    //---------------------------------------------
                                    RespconsTEF  := SA_ParsingTEF(resultado);
                                    Consultar_TEF := false;
                                    //---------------------------------------------
                                    frmwebtef.mensagem := RespconsTEF.mensagemResultado;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    //---------------------------------------------
                                 end;
                              //----------------------------------------------------
                           end
                        else   // Apenas esperar e fazer a apresenta��o da mensagem
                           begin
                              //---------------------------------------------------
                              if RespConsTEF.mensagemResultado<>'' then
                                 begin
                                    frmwebtef.mensagem := RespConsTEF.mensagemResultado;
                                    if RespConsTEF.linhasMensagemRetorno.Count>1 then
                                       begin
                                          frmwebtef.mensagem  := '';
                                          frmwebtef.mensagem1 := RespConsTEF.linhasMensagemRetorno[0];
                                          frmwebtef.mensagem2 := RespConsTEF.linhasMensagemRetorno[1];
                                       end;
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                                    Consultar_TEF := true;
                                 end;
                              //---------------------------------------------------
                              if RespConsTEF.automacao_coleta_retorno='9' then
                                 begin
                                    //---------------------------------------------
                                    TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                    while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    //---------------------------------------------
                                    sair          := true;
                                    TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                           end;
                        //---------------------------------------------------------
                     end
                  else    //   Opera��o deve ser encerrada
                     begin
                        //---------------------------------------------------------
                        if ((strtointdef(RespConsTEF.retorno,0)>=2) and (strtointdef(RespConsTEF.retorno,0)<=9)) or (RespConsTEF.retorno = '-1') then //   Ocorreu um erro que necessita finalizar a opera��o TEF
                           begin
                              //---------------------------------------------------
                              sair    := true;
                              //---------------------------------------------------
                              if RespConsTEF.retorno='9' then
                                 begin
                                    //---------------------------------------------
                                    resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,0));
                                    //---------------------------------------------
                                    SA_SalvarLog('Resposta CANCELAR:',resultado);
                                    //---------------------------------------------
                                 end;
                              //---------------------------------------------------
                              resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transa��o
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta FINALIZAR:',resultado);
                              //---------------------------------------------------
                              if RespConsTEF.mensagemResultado<>'' then
                                 frmwebtef.mensagem := RespConsTEF.mensagemResultado
                              else
                                 frmwebtef.mensagem := 'Ocorreu um erro na transa��o TEF...';
                              TThread.Synchronize(TThread.CurrentThread,SA_MostramensagemT);
                              TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                              while not frmwebtef.Cancelar do   // Esperando que o operador cancelar
                                 begin
                                    sleep(50);
                                 end;
                              TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                              //---------------------------------------------------
                           end
                        else if RespConsTEF.retorno='0' then  // Opera��o finalizada com sucesso
                           begin
                              //---------------------------------------------------
                              //   Capturar os dados da transa��o em BD
                              //---------------------------------------------------
                              LNSU               := RespConsTEF.nsuTerminal;
                              LNome_do_Produto   := RespConsTEF.tipoCartao;
                              LcAut              := RespConsTEF.codigoAutorizacao;
                              Lrede              := RespConsTEF.nomeProvedor;
                              LtBand             := RespConsTEF.nomeBandeira;
                              LCNPJAdquirente    := RespConsTEF.cnpjCredenciadora;
                              LdataHoraTransacao := RespConsTEF.dataHoraTransacao;
                              LSequencial        := strtointdef(RespConsTEF.sequencial,0);
                              //---------------------------------------------------
                              resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,1));  // Confirmar opera��o
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta CONFIRMAR:',resultado);
                              //---------------------------------------------------
                              resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transa��o
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta FINALIZAR:',resultado);
                              //---------------------------------------------------
                              //   TEF confirmado
                              //---------------------------------------------------
                              LTextoComprovanteLoja := '';
                              if RespConsTEF.comprovanteDiferenciadoLoja<>'' then
                                 begin
                                    LTextoComprovanteLoja := RespConsTEF.comprovanteDiferenciadoLoja;
                                    if LComprovanteLoja<>tpiNaoImprimir then
                                       begin
                                          TpComprovanteImprimir            := tpLoja;
                                          comprovanteDiferenciadoLoja      := TStringList.Create;
                                          comprovanteDiferenciadoLoja.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoLoja,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                          if LComprovanteLoja=tpiImprimir then
                                             begin
                                                if LViaLojaSimplificada then
                                                   GerenciadorImpressao.Corpo  := SA_GerarComprovanteSimplificado
                                                else  // Impress�o do comprovante do lojista normal
                                                   begin
                                                      //------------------------
                                                      if LImpressaoReduzida then
                                                         GerenciadorImpressao.Corpo  := SA_ResumirComprovante(comprovanteDiferenciadoLoja)
                                                      else
                                                         GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoLoja.Text;
                                                      //------------------------
                                                   end;
                                                GerenciadorImpressao.SA_Imprimir(1);
                                             end
                                          else if LComprovanteLoja=tpiPerguntar then
                                             begin
                                                //---------------------------------
                                                //   Perguntar se quer imprimir
                                                //---------------------------------
                                                opcoesColeta := TStringList.Create;
                                                opcoesColeta.Add('Imprimir');
                                                opcoesColeta.Add('N�o Imprimir');
                                                frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                                frmwebtef.opcoes   := opcoesColeta;
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //---------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                //--------------------------------
                                                while (not frmwebtef.Cancelar) do
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           //---------------------
                                                           //   Executar a impress�o
                                                           //---------------------
                                                           if LViaLojaSimplificada then
                                                              GerenciadorImpressao.Corpo  := SA_GerarComprovanteSimplificado
                                                           else
                                                              begin
                                                                 //------------
                                                                 if LImpressaoReduzida then
                                                                    GerenciadorImpressao.Corpo  := SA_ResumirComprovante(comprovanteDiferenciadoLoja)
                                                                 else
                                                                    GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoLoja.Text;
                                                                 //------------
                                                              end;
                                                           GerenciadorImpressao.SA_Imprimir(1);
                                                           frmwebtef.Cancelar := true;
                                                           //------------------
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                        frmwebtef.Cancelar := true;
                                                      //--------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                frmwebtef.Cancelar := false;
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                //------------------------------
                                             end;
                                          comprovanteDiferenciadoLoja.Free;
                                       end;
                                 end;
                              LTextoComprovanteCli := '';
                              if RespConsTEF.comprovanteDiferenciadoPortador<>'' then
                                 begin
                                    LTextoComprovanteCli := RespConsTEF.comprovanteDiferenciadoPortador;
                                    if LComprovanteCliente<>tpiNaoImprimir then
                                       begin
                                          TpComprovanteImprimir                := tpCliente;
                                          comprovanteDiferenciadoPortador      := TStringList.Create;
                                          comprovanteDiferenciadoPortador.Text := StringReplace(RespConsTEF.comprovanteDiferenciadoPortador,'\r\n',#13,[rfReplaceAll, rfIgnoreCase]);
                                          if LComprovanteCliente=tpiImprimir then
                                             begin
                                                //---------------------------------
                                                //  Imprimir autom�tico
                                                //---------------------------------
                                                if LImpressaoReduzida then
                                                   GerenciadorImpressao.Corpo       := SA_ResumirComprovante(comprovanteDiferenciadoPortador)
                                                else
                                                   GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoPortador.Text;
                                                GerenciadorImpressao.SA_Imprimir(1);
                                                //---------------------------------
                                             end
                                          else
                                             begin
                                                //---------------------------------
                                                //  Criar menu de imprimir
                                                //---------------------------------
                                                opcoesColeta := TStringList.Create;
                                                opcoesColeta.Add('Imprimir');
                                                opcoesColeta.Add('N�o Imprimir');
                                                frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                                frmwebtef.opcoes   := opcoesColeta;
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //---------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_CriarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_MostrarBtCancelarT);
                                                //--------------------------------
                                                while (not frmwebtef.Cancelar) do
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           //---------------------
                                                           //   Executar a impress�o
                                                           //---------------------
                                                           if LImpressaoReduzida then
                                                              GerenciadorImpressao.Corpo       := SA_ResumirComprovante(comprovanteDiferenciadoPortador)
                                                           else
                                                              GerenciadorImpressao.Corpo.Text  := comprovanteDiferenciadoPortador.Text;
                                                           GerenciadorImpressao.SA_Imprimir(1);
                                                           frmwebtef.Cancelar := true;
                                                           //---------------------
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) then
                                                        frmwebtef.Cancelar := true;
                                                      //--------------------------
                                                      sleep(50);
                                                   end;

                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarMenuT);
                                                TThread.Synchronize(TThread.CurrentThread,SA_DesativarBtCancelarT);
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          comprovanteDiferenciadoPortador.Free;
                                       end;
                                 end;
                              //---------------------------------------------------
                              sair := true;
                              //---------------------------------------------------
                           end;
                        //---------------------------------------------------------
                     end;
                  //---------------------------------------------------------------
                  //***************************************************************
                  //---------------------------------------------------------------
                  if (not sair) and (Consultar_TEF) then   // Se n�o � pra parar o LOOP, ent�o faz nova leitura
                     begin
                        //---------------------------------------------------------
                        sleep(100);
                        //---------------------------------------------------------
                        payload := TJsonObject.Create;
                        payload.AddPair('automacao_coleta_retorno',RespConsTEF.automacao_coleta_retorno);
                        payload.AddPair('automacao_coleta_sequencial',RespConsTEF.automacao_coleta_sequencial);
                        payload.AddPair('sequencial', LSequencial.ToString);
                        //---------------------------------------------------------
                        SA_SalvarLog('CONSULTA:',payload.ToString);
                        //---------------------------------------------------------
                        resultado   := UTF8ToString(RealizarPagamentoTEF( 0 , PAnsiChar(AnsiString(payload.ToString)), false));
                        //---------------------------------------------------------
                        SA_SalvarLog('Resposta CONSULTA:',resultado);
                        //---------------------------------------------------------
                        RespConsTEF  := SA_ParsingTEF(resultado);
                        //---------------------------------------------------------
                     end;
                  //---------------------------------------------------------------
                  if frmwebtef.Cancelar then
                     begin
                        //---------------------------------------------------------
                        sair := true;
                        //---------------------------------------------------------
                        if RespConsTEF.retorno='9' then
                           begin
                              //---------------------------------------------------
                              resultado   := UTF8ToString(ConfirmarOperacaoTEF(LSequencial,0));
                              //---------------------------------------------------
                              SA_SalvarLog('Resposta CANCELAR:',resultado);
                              //---------------------------------------------------
                           end;
                        //---------------------------------------------------------
                        resultado := UTF8ToString(FinalizarOperacaoTEF(1));   // Finalizando a transa��o
                        //---------------------------------------------------------
                        SA_SalvarLog('Resposta FINALIZAR:',resultado);
                        //---------------------------------------------------------
                     end;

               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------
end;

function TElginTEF.SA_RecuperarLinhasMensagem(mensagem:string): TStringList;
var
   d      : integer;
   linhas : TStringList;
begin
   Result      := TStringList.Create;
   try
      linhas      := TStringList.Create;
      linhas.Text := mensagem;
      for d := 1 to linhas.Count do
         begin
            if trim(linhas[d-1])<>'' then
               Result.Add(linhas[d-1]);
         end;
      linhas.Free;
   except
   end;

end;

function TElginTEF.SA_ResumirComprovante(texto: TStringList): TStringList;
var
   d : integer;
begin
   Result := TStringList.Create;
   for d := 1 to texto.Count do
      begin
         if trim(texto[d-1])<>'' then
            begin
               if trim(texto[d-1])<>'------------------------------------' then
                  Result.Add(copy(texto[d-1]+StringOfChar(' ',40),1,40))

            end;

      end;
end;

procedure TElginTEF.SA_SalvarLog(titulo,dado: string);
begin
   if LSalvarLog then
      SA_Salva_Arquivo_Incremental(titulo + ' ' + formatdatetime('dd/mm/yyyy hh:mm:ss',now)+#13+dado,GetCurrentDir+'\mkm_log\logTEFELGIN'+formatdatetime('yyyymmdd',date)+'.txt');
end;

procedure TElginTEF.SA_Salva_Arquivo_Incremental(linha, nome_arquivo: string);
var
   arquivo      : TextFile;
begin

   try
      AssignFile(arquivo,Nome_arquivo);
      if not FileExists(Nome_arquivo) then
         Rewrite(arquivo)
      else
         Append(arquivo);
      Writeln(arquivo,linha);
      CloseFile(arquivo);
   except
   end;
end;


function TElginTEF.SA_TpCartaoOperacaoTEFtoINT(  tipoCartao: TTpCartaoOperacaoTEF): integer;
begin
   Result := 99;
   case tipoCartao of
     tpPerguntar     : Result := 0;
     tpCartaoCredito : Result := 1;
     tpCartaoDebito  : Result := 2;
     tpVoucher       : Result := 3;
     tpFrota         : Result := 4;
     tpPrivateLabel  : Result := 5;
   end;
end;

function TElginTEF.SA_tpOperacaoADMToInt(tipo: ttpOperacaoADM): integer;
begin
   Result := 0;
   case tipo of
     tpOpPerguntar    : Result := 0;
     tpOpCancelamento : Result := 1;
     tpOpPendencias   : Result := 2;
     tpOpReimpressao  : Result := 3;
   end;
end;

function TElginTEF.transform(valor: real): string;
begin
   Result := '          '+formatfloat('###,###,##0.00',valor);
   Result := copy(Result,length(Result)-13,14);
end;

function TElginTEF.untransform(palavra: string): real;
var
   txt   : string;
   d     : integer;
begin
   txt:='';
   if palavra='' then
      palavra:='0,00';
   for d:=1 to length(palavra) do
      begin
         if CharInSet(palavra[d],['0'..'9',',','-']) then
            txt:=txt+palavra[d];
      end;
   //---------------------------------------------------------------------------
   try
      Result  := strtofloat(txt);
   except
      Result  := 0;
   end;
   //---------------------------------------------------------------------------

end;

function TElginTEF.vale(data: string): boolean;
begin
   try
      strtodate(data);
      Result := true;
   except
      Result := false;
   end;
end;

end.
