VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7635
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9600
   LinkTopic       =   "Form1"
   ScaleHeight     =   7635
   ScaleWidth      =   9600
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'=================================================
'     (c) John Company Inc. 2000-2001
'
'
'    That is basic use of johnaDX7 engine
'    it shows how to initialize the Backbuffer and Zbuffer engine
'    it show how to caps user key input from keyboard
'    for explanation
'    write me at Johna.pop@caramail.com
'
'    if you like my engine write me and vote for me
'    if you want the engine source code email me
''
'
'
'===================================================
'
'
' This is the Version 1.01
'   it support Texture maping
'   -Multitexturing 2 level on my P2 333 with phonix Vanta
'   -Fog linar or exponentiel
'   -Terrain gererating
'   -Texture creation from JPEG,BMP,GIF files
'   -Directsound is support and Dsound3d
'   -Direct music is support
'   -light mapping in multitexturing FX tools method
'   -hight precision terrain colision detection
'   -Basic actor camera mov
'           -Walk
'           -turn arround
'           -jumping
'           -and many more
'
'   -Basic geometric object genarating as cube ect..
'   -and many others interesting useful stuff.....
'
'
'
'    That is my first release
'    i cannot upload a full zip file with the engine DLL file
'    so i ain't got any website yet
'    You should write me at Johna.pop@caramail.com to have
'    a link for the dll file otherwise i can send it to anyone
'    that write me.......:)
'======================================================








'===Objects declaration====


Dim DX7 As New johna_DX7
Dim KUB_1   'first cube object
Dim FLOOR() As D3DLVERTEX
Dim SKY As New cDome_sky  'the sky object
Dim FLOOR_BUMP As DirectDrawSurface7
Dim KUB_BUMP As DirectDrawSurface7


Private Sub Form_Load()
Me.Refresh
Me.Show
DX7.Initialize_DX_Windowed Me.hWnd  'initialize engine in windowed mode
DX7.INiT_D3D Me.hWnd     'init the 3d engine
Call GAME_LOOP     'call the game loop
End Sub









'=========================================================
'  simple game loop
'  it finish when user toggle ESCAPE
'====================================================


Sub GAME_LOOP()
Dim RC As RECT


'init GFX

'=====Load the terrain map
'  parameters
'    -the 8bit graysacleBMP or JPEG or GIF file
'    -precision
'    -the Yfactor for MAX altitude
'    -TU for texture scaling X
'    -TU for texture scaling Y
'    -VertexTYPE
'    -the TEXTURE file name (BMP,GIF ,JPEG)


DX7.Terrain_LoadTerrain App.Path + "\data\height9.jpg", 7, 0.3, 8, 8, TV_VERTEX, App.Path + "\data\herbe1.bmp"


'======Create a simple Floor map

DX7.Make_PlaneSURF FLOOR(), DX7.johna_MakeVector(-500, 1, -500), DX7.johna_MakeVector(1500, 1, 1500), 254, 254, 255, 10, 10

'=======create the bump texture for multitexturing
Set FLOOR_BUMP = DX7.CreateTextureEX(App.Path + "\data\herbe_bump.bmp", 256, 256)




'=======Place the camera actor EYE the current orientation is the Degree=0
DX7.Camera_set_EYE DX7.johna_MakeVector(10, 10, 10)


'==============SKY object initialisation

SKY.Init DX7, App.Path + "\data\ciel2.x", App.Path + "\data\ciel.bmp"

SKY.SKY_scale = 14


'================create a building
KUB_1 = DX7.ADD_cubeEXTERN_face(DX7.johna_MakeVector(-200, 0, -200), DX7.johna_MakeVector(100, 250, 300), 250, 250, 250, App.Path + "\data\facade2.jpg", 1, 1)

'=======create the bump texture for multitexturing
Set KUB_BUMP = DX7.CreateTextureEX(App.Path + "\data\facade_bump.jpg", 256, 256)



LIT = DX7.ADD_light(D3DLIGHT_SPOT, DX7.johna_MakeVector(10, 10, 10), DX7.D3Dcolor(0.1, 0.4, 0.5, 1), DX7.D3Dcolor(0.1, 0.4, 0.5, 1), 50, DX7.D3Dcolor(0.1, 0.4, 0.5, 1))





Do
  DoEvents
  If DX7.GetKEY(DIK_ESCAPE) Then GoTo END_it
  'checkeys
  Call Me.KEY_check







  'Render 3d
  DX7.D3D_DEV.BeginScene
  DX7.Clear_3D
  
  'example of FOG use
  'DX7.SETfog_EX 50, 505, RGB(254, 254, 25)
  
  
  
  'DX7.MULTITEXTURE_FX_Dark_Mapping 1, FLOOR_BUMP
  DX7.Terrain_RenderAll
  'DX7.Disable_MULTITEXTURE
  

  DX7.Render_surf FLOOR, 4
  
  
  
  DX7.MULTITEXTURE_FX_Dark_Mapping 1, KUB_BUMP
  DX7.Render_EXTERNcube KUB_1, 1
  DX7.Disable_MULTITEXTURE
  
  
  SKY.Render DX7
  
  DX7.D3D_DEV.EndScene
  'end rendering


  DX7.BAK.DrawText 10, 40, "FramePER seconde=" + Str(DX7.FramesPerSec), 0
  DX7.BAK.DrawText 10, 60, "PRESS SPACE for reset camera", 0
  
  
  
  DX7.FLIPP Me.hWnd
Loop


END_it:

DX7.FreeDX Me.hWnd
End



End Sub





Sub KEY_check()

If DX7.GetKEY(DIK_UP) Then _
  DX7.Camera_Move_Foward 1

If DX7.GetKEY(DIK_DOWN) Then _
  DX7.Camera_Move_Backward 1



If DX7.GetKEY(DIK_LEFT) Then _
  DX7.Camera_Move_Left 0.0005

If DX7.GetKEY(DIK_RIGHT) Then _
  DX7.Camera_Move_Right 0.0005


If DX7.GetKEY(DIK_NUMPAD8) Then _
  DX7.Camera_Move_UP 0.0005

If DX7.GetKEY(DIK_NUMPAD2) Then _
  DX7.Camera_Move_DOWN 0.0005



If DX7.GetKEY(DIK_NUMPAD4) Then _
  DX7.CAM_step_LEFT 1

If DX7.GetKEY(DIK_NUMPAD6) Then _
  DX7.CAM_step_RIGHT 1


If DX7.GetKEY(DIK_SPACE) Then _
  DX7.Camera_set_EYE DX7.johna_MakeVector(10, 10, 10)






Dim VC As D3DVECTOR
Dim TempVC As D3DVECTOR

VC = DX7.GET_CameraEYE

VC.y = DX7.Terrain_GetHeight(VC) + 10

DX7.Camera_set_EYE VC

End Sub

