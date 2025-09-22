// table 50001 "Spec sheet"
// {
//     DrillDownPageID = "Spec sheet";
//     LookupPageID = "Spec sheet";

//     fields
//     {
//         field(1; "Product Group Code"; Code[20])
//         {
//             TableRelation = "Product Group".Code;
//         }
//         field(2; "Unit of Measure"; Option)
//         {
//             OptionCaption = 'Yards,Meters';
//             OptionMembers = Yards,Meters;
//         }
//         field(3; "Standard Width"; Decimal)
//         {
//         }
//         field(4; "Minimum Width"; Decimal)
//         {
//         }
//         field(5; "Maximum Width"; Decimal)
//         {
//         }
//         field(6; "Fabric Embroidery"; Boolean)
//         {
//         }
//         field(7; "Embroidery Width"; Decimal)
//         {
//         }
//         field(9; "Primary HS Code"; Code[20])
//         {
//             TableRelation = "Tariff Number";
//         }
//         field(10; "Secondary HS Code"; Code[20])
//         {
//             TableRelation = "Tariff Number";
//         }
//         field(13; "Fiber Contents"; Code[20])
//         {
//             TableRelation = "Item Spec Contents";
//         }
//         field(15; "Vertical Repeat"; Decimal)
//         {
//         }
//         field(16; "Horizontal Repeat"; Decimal)
//         {
//         }
//         field(19; "Fabric Construction"; Option)
//         {
//             InitValue = Woven;
//             OptionCaption = 'Knit,Woven,Tulle or Net,Lace,Non Woven,Embroidery W/O Visible Ground';
//             OptionMembers = Knit,Woven,"Tulle or Net",Lace,"Non Woven","Embroidery W/O Visible Ground";
//         }
//         field(20; "Type Of Weave"; Option)
//         {
//             OptionCaption = 'Plain,Jacquard,Dobby,Twill,Satin,Leno,Other';
//             OptionMembers = Plain,Jacquard,Dobby,Twill,Satin,Leno,Other;
//         }
//         field(21; "Yarn Size Warp"; Text[60])
//         {
//         }
//         field(22; "Yarn Size Weft"; Text[60])
//         {
//         }
//         field(23; "Average Yarn No."; Decimal)
//         {
//         }
//         field(24; "Fabric Coloring"; Option)
//         {
//             OptionCaption = 'Greige,Yarn Dyed,Piece Dyed,Dyed White,Unbleached,Bleached,Printed,Discharge Printing';
//             OptionMembers = Greige,"Yarn Dyed","Piece Dyed","Dyed White",Unbleached,Bleached,Printed,"Discharge Printing";
//         }
//         field(28; "TPM WARP"; Text[10])
//         {
//         }
//         field(29; "TPM Weft"; Text[10])
//         {
//         }
//         field(31; IfFilamentYarn; Code[10])
//         {
//         }
//         field(32; "Seam Slippage: ASTMD4034"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Pass with Backing,Fail';
//             OptionMembers = "Not Tested",Pass,"Pass with Backing",Fail;
//         }
//         field(33; "Pilling: ASTM D4970"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(35; "Average Piece Size"; Text[50])
//         {
//         }
//         field(36; "Pattern Match"; Option)
//         {
//             OptionCaption = 'Half Drop,Side Matching,None';
//             OptionMembers = "Half Drop","Side Matching","None";
//         }
//         field(37; "Weight GSM"; Decimal)
//         {
//         }
//         field(38; "Cleaning Code"; Code[50])
//         {
//             TableRelation = "Item Spec Cleaning Code";
//         }
//         field(39; "Railroaded/Up the Roll/None"; Option)
//         {
//             OptionCaption = 'Railroaded,Up The Roll,None';
//             OptionMembers = Railroaded,"Up The Roll","None";
//         }
//         field(40; Reversible; Boolean)
//         {
//         }
//         field(41; "Vendor Exclusivity"; Option)
//         {
//             OptionCaption = 'NAFTA Confinement,Regional,USA,WORLD WIDE EXCLUSIVE,None';
//             OptionMembers = "NAFTA Confinement",Regional,USA,"WORLD WIDE EXCLUSIVE","None";
//         }
//         field(42; "Customer Exclusivity"; Option)
//         {
//             OptionCaption = ' ,NAFTA Confinement,Regional,USA,None';
//             OptionMembers = " ","NAFTA Confinement",Regional,USA,"None";
//         }
//         field(43; Notes; Text[50])
//         {
//         }
//         field(47; "Fabric Rolled"; Option)
//         {
//             OptionCaption = 'Face In,Face Out,n/a';
//             OptionMembers = "Face In","Face Out","n/a";
//         }
//         field(48; Finish; Text[100])
//         {
//             InitValue = 'None';
//         }
//         field(49; Backing; Option)
//         {
//             OptionCaption = 'None,Acrylic,Knit,Latex,Other';
//             OptionMembers = "None",Acrylic,Knit,Latex,Other;
//         }
//         field(50; "Print Method"; Option)
//         {
//             OptionCaption = 'None,Pigment,Vat,Reactive,Screens,Other';
//             OptionMembers = "None",Pigment,Vat,Reactive,Screens,Other;
//         }
//         field(51; "No of Screens"; Decimal)
//         {
//         }
//         field(52; "Martindale Test"; Decimal)
//         {
//         }
//         field(53; "Wyzenbeek Cotton Duck"; Decimal)
//         {
//         }
//         field(54; "Wyzenbeek Wire Mesh"; Decimal)
//         {
//         }
//         field(55; "Light Fastness AACTCC 16 Opt 3"; Decimal)
//         {
//         }
//         field(56; "FLAME: TB117-2013 Compliance"; Boolean)
//         {
//         }
//         field(57; "Usability: Curtains"; Boolean)
//         {
//         }
//         field(58; "Usability: Loose Covers"; Boolean)
//         {
//         }
//         field(59; "Usability: Upholsery"; Boolean)
//         {
//         }
//         field(60; "Usability: Pillows and Spreads"; Boolean)
//         {
//         }
//         field(61; "Usability: General Contract"; Boolean)
//         {
//         }
//         field(62; "Protective Finish"; Option)
//         {
//             Caption = 'Protective Finish';
//             OptionCaption = 'None,SCOTCHGARD,SOIL & STAIN REPELLENT,TEFLON,WATER REPELLENT';
//             OptionMembers = "None",SCOTCHGARD,"SOIL & STAIN REPELLENT",TEFLON,"WATER REPELLENT";
//         }
//         field(64; "FLAME: BOSTON BFD-IX-1"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(66; "FLAME: CAL-117"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(67; "FLAME: FMVSS 302"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(68; "FLAME: NFPA-260A"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(69; "FLAME: NFPA-701"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(70; "FLAME: UFAC-1"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(71; "Country of Origin"; Code[10])
//         {
//             TableRelation = "Country/Region";
//         }
//         field(72; "Introduction Date"; Date)
//         {
//         }
//         field(73; "Mill Code"; Code[30])
//         {
//             TableRelation = Vendor."No." WHERE("Vendor Posting Group" = FILTER('CURR. VEND'));
//         }
//         field(74; "Mill SKU#"; Text[30])
//         {
//         }
//         field(75; "Continuity (# of Years)"; Option)
//         {
//             InitValue = "5";
//             OptionCaption = '1,2,3,4,5,6,7,8,9';
//             OptionMembers = "1","2","3","4","5","6","7","8","9";
//         }
//         field(76; "Cost in Meters"; Decimal)
//         {
//         }
//         field(77; "Cost in Yards"; Decimal)
//         {
//         }
//         field(78; "Weight Oz Linear Yd"; Decimal)
//         {
//         }
//         field(79; "State if fabirc is napped"; Boolean)
//         {
//         }
//         field(80; "State % of Noil & Silk Waste"; Decimal)
//         {
//         }
//         field(83; "Seam Slippage: ASTMD434 Draper"; Option)
//         {
//             OptionCaption = 'Not Tested,Pass,Fail';
//             OptionMembers = "Not Tested",Pass,Fail;
//         }
//         field(84; "Fiber Reactive Dyes"; Boolean)
//         {
//         }
//         field(85; "Embroidery: Seams in a roll"; Decimal)
//         {
//         }
//         field(86; "Emb: Plain fabric Weight"; Decimal)
//         {
//         }
//         field(87; "Embroidery: Fiber Contents"; Text[30])
//         {
//         }
//         field(88; "Form Filled by:"; Text[30])
//         {
//         }
//         field(89; "Warp: Single yarns per CM"; Text[50])
//         {
//         }
//         field(90; "Weft: Single yarns per CM"; Text[50])
//         {
//         }
//         field(91; Completed; Boolean)
//         {
//         }
//         field(92; "MOQ (Min. Order Qty)"; Decimal)
//         {
//         }
//         field(96; "Date Created"; DateTime)
//         {
//         }
//         field(97; "Date Updated"; DateTime)
//         {
//         }
//         field(98; ID; BigInteger)
//         {
//         }
//         field(99; "High Tenacity"; Boolean)
//         {
//         }
//         field(100; Solid; Boolean)
//         {
//         }
//         field(101; Abstract; Boolean)
//         {
//         }
//         field(102; Animal; Boolean)
//         {
//         }
//         field(103; "Animal Skin"; Boolean)
//         {
//         }
//         field(104; Asian; Boolean)
//         {
//         }
//         field(105; Birds; Boolean)
//         {
//         }
//         field(106; Botanical; Boolean)
//         {
//         }
//         field(107; Canvas; Boolean)
//         {
//         }
//         field(108; Check; Boolean)
//         {
//         }
//         field(109; Chenille; Boolean)
//         {
//         }
//         field(110; Chevron; Boolean)
//         {
//         }
//         field(111; Chintz; Boolean)
//         {
//         }
//         field(112; Contemporary; Boolean)
//         {
//         }
//         field(113; Corduroy; Boolean)
//         {
//         }
//         field(114; Crewel; Boolean)
//         {
//         }
//         field(115; Damask; Boolean)
//         {
//         }
//         field(116; Denim; Boolean)
//         {
//         }
//         field(117; Diamond; Boolean)
//         {
//         }
//         field(118; "Dots/Circles"; Boolean)
//         {
//         }
//         field(119; Embroidery; Boolean)
//         {
//         }
//         field(120; Epingle; Boolean)
//         {
//         }
//         field(121; Eyelet; Boolean)
//         {
//         }
//         field(122; Ethnic; Boolean)
//         {
//         }
//         field(123; "Flame Stitch"; Boolean)
//         {
//         }
//         field(124; Floral; Boolean)
//         {
//         }
//         field(125; Geometric; Boolean)
//         {
//         }
//         field(126; "Greek Key"; Boolean)
//         {
//         }
//         field(127; "Gros Point"; Boolean)
//         {
//         }
//         field(128; Herringbone; Boolean)
//         {
//         }
//         field(129; Houndstooth; Boolean)
//         {
//         }
//         field(130; Ikat; Boolean)
//         {
//         }
//         field(131; Imberlines; Boolean)
//         {
//         }
//         field(132; Insect; Boolean)
//         {
//         }
//         field(133; Jacobean; Boolean)
//         {
//         }
//         field(134; Juvenile; Boolean)
//         {
//         }
//         field(135; Kilim; Boolean)
//         {
//         }
//         field(136; Lace; Boolean)
//         {
//         }
//         field(137; "Leaf/Foliage/Vine"; Boolean)
//         {
//         }
//         field(138; Matelasse; Boolean)
//         {
//         }
//         field(139; "Medallion/Tile"; Boolean)
//         {
//         }
//         field(140; Metallic; Boolean)
//         {
//         }
//         field(141; Moire; Boolean)
//         {
//         }
//         field(142; Nautical; Boolean)
//         {
//         }
//         field(143; Ogee; Boolean)
//         {
//         }
//         field(144; Ombre; Boolean)
//         {
//         }
//         field(145; Ottoman; Boolean)
//         {
//         }
//         field(146; Paisley; Boolean)
//         {
//         }
//         field(147; Plaid; Boolean)
//         {
//         }
//         field(148; Pleated; Boolean)
//         {
//         }
//         field(149; "Polka Dot"; Boolean)
//         {
//         }
//         field(150; Quilted; Boolean)
//         {
//         }
//         field(151; Raffia; Boolean)
//         {
//         }
//         field(152; Railroaded; Boolean)
//         {
//         }
//         field(153; Sateen; Boolean)
//         {
//         }
//         field(154; Satin; Boolean)
//         {
//         }
//         field(155; Script; Boolean)
//         {
//         }
//         field(156; Scroll; Boolean)
//         {
//         }
//         field(157; Sheer; Boolean)
//         {
//         }
//         field(158; "Sheer Casement"; Boolean)
//         {
//         }
//         field(159; "Sheer Semi"; Boolean)
//         {
//         }
//         field(160; "Southwest/Lodge"; Boolean)
//         {
//         }
//         field(161; Strie; Boolean)
//         {
//         }
//         field(162; Stripe; Boolean)
//         {
//         }
//         field(163; Tapestry; Boolean)
//         {
//         }
//         field(164; Texture; Boolean)
//         {
//         }
//         field(165; Toile; Boolean)
//         {
//         }
//         field(166; "Trellis/Lattice"; Boolean)
//         {
//         }
//         field(167; Tropical; Boolean)
//         {
//         }
//         field(168; Tweed; Boolean)
//         {
//         }
//         field(169; Twill; Boolean)
//         {
//         }
//         field(170; "Velvet-Cut"; Boolean)
//         {
//         }
//         field(171; Vermicelli; Boolean)
//         {
//         }
//         field(172; Washed; Boolean)
//         {
//         }
//         field(173; "Wide Width"; Boolean)
//         {
//         }
//         field(174; Linen; Boolean)
//         {
//         }
//         field(175; Print; Boolean)
//         {
//         }
//         field(176; Silk; Boolean)
//         {
//         }
//         field(177; Velvet; Boolean)
//         {
//         }
//         field(178; Woven; Boolean)
//         {
//         }
//         field(179; "All Sizes"; Boolean)
//         {
//         }
//         field(180; Small; Boolean)
//         {
//         }
//         field(181; Medium; Boolean)
//         {
//         }
//         field(182; Large; Boolean)
//         {
//         }
//         field(183; Bedding; Boolean)
//         {
//         }
//         field(184; Contract; Boolean)
//         {
//         }
//         field(185; "Indoor/Outdoor"; Boolean)
//         {
//         }
//         field(186; "Anti-Bacterial/Microbial"; Boolean)
//         {
//         }
//         field(187; "Fade Resistant"; Boolean)
//         {
//         }
//         field(188; "Mildew Resistant"; Boolean)
//         {
//         }
//     }

//     keys
//     {
//         key(Key1; "Product Group Code")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }

//     var
//         EnableWidth: Boolean;
// }

