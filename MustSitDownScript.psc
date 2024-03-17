Scriptname MustSitDownScript extends ReferenceAlias  

; How long in seconds the update interval
float Property UpdateInterval = 0.25 Auto 

; How much damage to take every Update Interval
float Property DamageToTake = 1.0 Auto

; Whether or not the mod is enabled
Bool isModEnabled ; = False

; Stores how long the game has not been cleaned up in
float Property _cleanupCurrentTime = 0.0 Auto

; How long of an interval the clean up is
float Property cleanupTime = 60.0 Auto

; Key to press and hold to enable the mod (If this mod is off then NOTHING spawns)
Int Property modEnablerKey = 199  Auto ; Home key enables and disables mode

Int Property chairSpawnKey = 3 Auto; 2 Key; 
Int Property benchSpawnKey = 4 Auto; 3 Key; 

; Array storing the chair object references
ObjectReference[] Property chairArray Auto;

; Array storing the bench object references
ObjectReference[] Property benchArray Auto;

; Current amount of chairs
Int Property currentAmountOfChairs = 0 Auto;

; Current amount of benches
Int Property currentAmountOfBenches = 0 Auto;

; Mode switcher keys
Int Property easyModeKey = 9 Auto; 8 Key; 
Int Property mediumModeKey = 10 Auto; 9 Key; 
Int Property hardModeKey = 11 Auto; 0 Key; 

; Easy Mode Multiplier
Float Property easyMultiplier = 1.0 Auto 

; Medium Mode Multiplier
Float Property meduimMultiplier = 2.0 Auto 

; Hard Mode Multiplier
Float Property hardMultiplier = 3.0 Auto 

; Current multiplier (Default to easy value)
Float Property currentMultiplier = 1.0 Auto 


Event OnInit()
    ; Setup the chair and bench array variables
    chairArray = new ObjectReference[128]
    benchArray = new ObjectReference[128]
            
    ;Register the first update to be called every x amount of seconds
	RegisterForSingleUpdate(UpdateInterval)
EndEvent

Event OnUpdate()

    ;Enabling and disabling the mod
	If modEnablerKey == Input.IsKeyPressed(modEnablerKey)
		isModEnabled = !isModEnabled
        If isModEnabled
            Debug.Notification("Mod is now Enabled")
        Else
            Debug.Notification("Mod is now Disabled")
        EndIf
	EndIf

    ; If the mod is enabled then we execute
    If isModEnabled
        ; Check to see which mode we are going to enable
        If easyModeKey == Input.IsKeyPressed(easyModeKey)
            Debug.Notification("Enabling easy mode")
            currentMultiplier = easyMultiplier
        EndIf

        If mediumModeKey == Input.IsKeyPressed(mediumModeKey)
            Debug.Notification("Enabling medium mode")
            currentMultiplier = meduimMultiplier
        EndIf
        
        If hardModeKey == Input.IsKeyPressed(hardModeKey)
            Debug.Notification("Enabling hard mode")
            currentMultiplier = hardMultiplier
        EndIf
        
        ; Get whether or not the player is currently sitting
        bool isSitting = Game.GetPlayer().GetSitState() != 0
        
        ; Damage the player
        If !isSitting 
            Game.GetPlayer().DamageActorValue("Health", DamageToTake * currentMultiplier)   
        EndIf

        ; Logic to spawn chair
        If chairSpawnKey == Input.IsKeyPressed(chairSpawnKey) && currentAmountOfChairs < 128
            ; Spawn the chair and get a reference to it
            ObjectReference chair = Game.GetPlayer().PlaceAtMe(Game.GetForm(0x0006d90f))

            ; Add it to the chair array
            chairArray[currentAmountOfChairs] = chair

            ; Increment the number of current chairs
            currentAmountOfChairs += 1
        EndIf

        ; Logic to spawn bench
        If benchSpawnKey == Input.IsKeyPressed(benchSpawnKey) && currentAmountOfBenches < 128
            ; Spawn the bench and get a reference to it
            ObjectReference bench = Game.GetPlayer().PlaceAtMe(Game.GetForm(0x000c07f3))

            ; Add it to the bench array
            benchArray[currentAmountOfBenches] = bench

            ; Increment the number of current benches
            currentAmountOfBenches += 1
        EndIf        

        ; Logic to cleanup the environment
        If _cleanupCurrentTime > cleanupTime
            Int i = 0
            While i < currentAmountOfChairs
                ObjectReference chairToDelete = chairArray[i] 
                chairToDelete.Disable(false)
                i += 1
            EndWhile

            Int b = 0
            While b < currentAmountOfBenches
                ObjectReference benchToDelete = benchArray[b] 
                benchToDelete.Disable(false)
                b += 1
            EndWhile

            ; Clean up the list
            chairArray = new ObjectReference[128]
            benchArray = new ObjectReference[128]
            currentAmountOfChairs = 0
            currentAmountOfBenches
            _cleanupCurrentTime = 0
        Else 
            ; Otherwise increment the clean up current time by the update interval
            _cleanupCurrentTime += UpdateInterval
        EndIf
        
    EndIf    

    ; Recall the update interval
	RegisterForSingleUpdate(UpdateInterval)
EndEvent

Event OnSit(ObjectReference akFurniture)
    Game.GetPlayer().RestoreActorValue("health", 100)
EndEvent


; Map of all of the key values to keyboard 

; 0x01     1  Escape
; 0x02     2  1
; 0x03     3  2
; 0x04     4  3
; 0x05     5  4
; 0x06     6  5
; 0x07     7  6
; 0x08     8  7
; 0x09     9  8
; 0x0A    10  9
; 0x0B    11  0
; 0x0C    12  Minus
; 0x0D    13  Equals
; 0x0E    14  Backspace
; 0x0F    15  Tab
; 0x10    16  Q
; 0x11    17  W
; 0x12    18  E
; 0x13    19  R
; 0x14    20  T
; 0x15    21  Y
; 0x16    22  U
; 0x17    23  I
; 0x18    24  O
; 0x19    25  P
; 0x1A    26  Left Bracket
; 0x1B    27  Right Bracket
; 0x1C    28  Enter
; 0x1D    29  Left Control
; 0x1E    30  A
; 0x1F    31  S
; 0x20    32  D
; 0x21    33  F
; 0x22    34  G
; 0x23    35  H
; 0x24    36  J
; 0x25    37  K
; 0x26    38  L
; 0x27    39  Semicolon
; 0x28    40  Apostrophe
; 0x29    41  ~ (Console)
; 0x2A    42  Left Shift
; 0x2B    43  Back Slash
; 0x2C    44  Z
; 0x2D    45  X
; 0x2E    46  C
; 0x2F    47  V
; 0x30    48  B
; 0x31    49  N
; 0x32    50  M
; 0x33    51  Comma
; 0x34    52  Period
; 0x35    53  Forward Slash  
; 0x36    54  Right Shift
; 0x37    55  NUM*
; 0x38    56  Left Alt
; 0x39    57  Spacebar
; 0x3A    58  Caps Lock
; 0x3B    59  F1
; 0x3C    60  F2
; 0x3D    61  F3
; 0x3E    62  F4
; 0x3F    63  F5
; 0x40    64  F6
; 0x41    65  F7
; 0x42    66  F8
; 0x43    67  F9
; 0x44    68  F10
; 0x45    69  Num Lock
; 0x46    70  Scroll Lock
; 0x47    71  NUM7
; 0x48    72  NUM8
; 0x49    73  NUM9
; 0x4A    74  NUM-
; 0x4B    75  NUM4
; 0x4C    76  NUM5
; 0x4D    77  NUM6
; 0x4E    78  NUM+
; 0x4F    79  NUM1
; 0x50    80  NUM2
; 0x51    81  NUM3
; 0x52    82  NUM0
; 0x53    83  NUM.
; 0x57    87  F11
; 0x58    88  F12
; 0x9C   156  NUM Enter
; 0x9D   157  Right Control
; 0xB5   181  NUM/
; 0xB7   183  SysRq / PtrScr
; 0xB8   184  Right Alt
; 0xC5   197  Pause
; 0xC7   199  Home
; 0xC8   200  Up Arrow
; 0xC9   201  PgUp
; 0xCB   203  Left Arrow
; 0xCD   205  Right Arrow
; 0xCF   207  End
; 0xD0   208  Down Arrow
; 0xD1   209  PgDown
; 0xD2   210  Insert
; 0xD3   211  Delete
; 0x100  256  Left Mouse Button
; 0x101  257  Right Mouse Button
; 0x102  258  Middle/Wheel Mouse Button
; 0x103  259  Mouse Button 3
; 0x104  260  Mouse Button 4
; 0x105  261  Mouse Button 5
; 0x106  262  Mouse Button 6
; 0x107  263  Mouse Button 7
; 0x108  264  Mouse Wheel Up
; 0x109  265  Mouse Wheel Down
