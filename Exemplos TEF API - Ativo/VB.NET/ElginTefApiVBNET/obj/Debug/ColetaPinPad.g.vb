﻿#ExternalChecksum("..\..\ColetaPinPad.xaml","{8829d00f-11b8-4213-878b-770e8597ac16}","06552DF5CD050BEE37A651AADAC3B48DEAEB3D298E5939116A8257AFD76B9511")
'------------------------------------------------------------------------------
' <auto-generated>
'     O código foi gerado por uma ferramenta.
'     Versão de Tempo de Execução:4.0.30319.42000
'
'     As alterações ao arquivo poderão causar comportamento incorreto e serão perdidas se
'     o código for gerado novamente.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict Off
Option Explicit On

Imports ElginTefApiVBNET
Imports System
Imports System.Diagnostics
Imports System.Windows
Imports System.Windows.Automation
Imports System.Windows.Controls
Imports System.Windows.Controls.Primitives
Imports System.Windows.Data
Imports System.Windows.Documents
Imports System.Windows.Ink
Imports System.Windows.Input
Imports System.Windows.Markup
Imports System.Windows.Media
Imports System.Windows.Media.Animation
Imports System.Windows.Media.Effects
Imports System.Windows.Media.Imaging
Imports System.Windows.Media.Media3D
Imports System.Windows.Media.TextFormatting
Imports System.Windows.Navigation
Imports System.Windows.Shapes
Imports System.Windows.Shell


'''<summary>
'''ColetaPinPad
'''</summary>
<Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>  _
Partial Public Class ColetaPinPad
    Inherits System.Windows.Window
    Implements System.Windows.Markup.IComponentConnector
    
    
    #ExternalSource("..\..\ColetaPinPad.xaml",11)
    <System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")>  _
    Friend WithEvents txtLogs As System.Windows.Controls.TextBox
    
    #End ExternalSource
    
    
    #ExternalSource("..\..\ColetaPinPad.xaml",15)
    <System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")>  _
    Friend WithEvents cmbTipoColeta As System.Windows.Controls.ComboBox
    
    #End ExternalSource
    
    
    #ExternalSource("..\..\ColetaPinPad.xaml",21)
    <System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")>  _
    Friend WithEvents rdbNotConfirm As System.Windows.Controls.RadioButton
    
    #End ExternalSource
    
    
    #ExternalSource("..\..\ColetaPinPad.xaml",22)
    <System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")>  _
    Friend WithEvents rdbConfirm As System.Windows.Controls.RadioButton
    
    #End ExternalSource
    
    
    #ExternalSource("..\..\ColetaPinPad.xaml",23)
    <System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")>  _
    Friend WithEvents btnRealizarColetaPinPad As System.Windows.Controls.Button
    
    #End ExternalSource
    
    
    #ExternalSource("..\..\ColetaPinPad.xaml",25)
    <System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")>  _
    Friend WithEvents lblValorColetado As System.Windows.Controls.Label
    
    #End ExternalSource
    
    Private _contentLoaded As Boolean
    
    '''<summary>
    '''InitializeComponent
    '''</summary>
    <System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
     System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")>  _
    Public Sub InitializeComponent() Implements System.Windows.Markup.IComponentConnector.InitializeComponent
        If _contentLoaded Then
            Return
        End If
        _contentLoaded = true
        Dim resourceLocater As System.Uri = New System.Uri("/ElginTefApiVBNET;component/coletapinpad.xaml", System.UriKind.Relative)
        
        #ExternalSource("..\..\ColetaPinPad.xaml",1)
        System.Windows.Application.LoadComponent(Me, resourceLocater)
        
        #End ExternalSource
    End Sub
    
    <System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
     System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0"),  _
     System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never),  _
     System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes"),  _
     System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity"),  _
     System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")>  _
    Sub System_Windows_Markup_IComponentConnector_Connect(ByVal connectionId As Integer, ByVal target As Object) Implements System.Windows.Markup.IComponentConnector.Connect
        If (connectionId = 1) Then
            Me.txtLogs = CType(target,System.Windows.Controls.TextBox)
            
            #ExternalSource("..\..\ColetaPinPad.xaml",11)
            AddHandler Me.txtLogs.TextChanged, New System.Windows.Controls.TextChangedEventHandler(AddressOf Me.txtLogs_TextChanged)
            
            #End ExternalSource
            Return
        End If
        If (connectionId = 2) Then
            Me.cmbTipoColeta = CType(target,System.Windows.Controls.ComboBox)
            Return
        End If
        If (connectionId = 3) Then
            Me.rdbNotConfirm = CType(target,System.Windows.Controls.RadioButton)
            Return
        End If
        If (connectionId = 4) Then
            Me.rdbConfirm = CType(target,System.Windows.Controls.RadioButton)
            Return
        End If
        If (connectionId = 5) Then
            Me.btnRealizarColetaPinPad = CType(target,System.Windows.Controls.Button)
            
            #ExternalSource("..\..\ColetaPinPad.xaml",23)
            AddHandler Me.btnRealizarColetaPinPad.Click, New System.Windows.RoutedEventHandler(AddressOf Me.Button_Click)
            
            #End ExternalSource
            Return
        End If
        If (connectionId = 6) Then
            Me.lblValorColetado = CType(target,System.Windows.Controls.Label)
            Return
        End If
        Me._contentLoaded = true
    End Sub
End Class

