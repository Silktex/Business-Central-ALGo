// codeunit 50219 SalesPriceCalcMgt_Ext
// {
//     var
//         GLSetup: Record "General Ledger Setup";
//         Item: Record Item;
//         ResPrice: Record "Resource Price";
//         Res: Record Resource;
//         Currency: Record Currency;
//         Text000: Label '%1 is less than %2 in the %3.';
//         Text010: Label 'Prices including Tax cannot be calculated when %1 is %2.';
//         TempSalesPrice: Record "Sales Price" temporary;
//         TempSalesLineDisc: Record "Sales Line Discount" temporary;
//         LineDiscPerCent: Decimal;
//         Qty: Decimal;
//         AllowLineDisc: Boolean;
//         AllowInvDisc: Boolean;
//         VATPerCent: Decimal;
//         PricesInclVAT: Boolean;
//         VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
//         VATBusPostingGr: Code[20];
//         QtyPerUOM: Decimal;
//         PricesInCurrency: Boolean;
//         CurrencyFactor: Decimal;
//         ExchRateDate: Date;
//         Text018: Label '%1 %2 is greater than %3 and was adjusted to %4.';
//         FoundSalesPrice: Boolean;
//         Text001: Label 'The %1 in the %2 must be same as in the %3.';
//         HideResUnitPriceMessage: Boolean;
//         DateCaption: Text[30];
//         Cust: Record Customer;

//     [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Price Calc. Mgt.", 'OnBeforeFindItemJnlLinePrice', '', false, false)]
//     local procedure OnBeforeFindItemJnlLinePrice(var ItemJournalLine: Record "Item Journal Line"; CalledByFieldNo: Integer; var IsHandled: Boolean)
//     begin
//         SetCurrency('', 0, 0D);
//         SetVAT(false, 0, 0, '');
//         SetUoM(Abs(ItemJournalLine.Quantity), ItemJournalLine."Qty. per Unit of Measure");
//         ItemJournalLine.TestField("Qty. per Unit of Measure");
//         Item.Get(ItemJournalLine."Item No.");

//         FindSalesPrice(
//           TempSalesPrice, '', '', '', '', ItemJournalLine."Item No.", ItemJournalLine."Variant Code",
//           ItemJournalLine."Unit of Measure Code", '', ItemJournalLine."Posting Date", false, ItemJournalLine."Product Group Code", ItemJournalLine."Location Code");
//         CalcBestUnitPrice(TempSalesPrice);
//         if FoundSalesPrice or
//            not ((CalledByFieldNo = ItemJournalLine.FieldNo(Quantity)) or
//                 (CalledByFieldNo = ItemJournalLine.FieldNo("Variant Code")))
//         then
//             ItemJournalLine.Validate("Unit Amount", TempSalesPrice."Unit Price");

//         IsHandled := true;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales Price Calc. Mgt.", 'OnBeforeFindStdItemJnlLinePrice', '', false, false)]
//     local procedure OnBeforeFindStdItemJnlLinePrice(var StandardItemJournalLine: Record "Standard Item Journal Line"; CalledByFieldNo: Integer; var IsHandled: Boolean)
//     begin
//         SetCurrency('', 0, 0D);
//         SetVAT(false, 0, 0, '');
//         SetUoM(Abs(StandardItemJournalLine.Quantity), StandardItemJournalLine."Qty. per Unit of Measure");
//         StandardItemJournalLine.TestField("Qty. per Unit of Measure");
//         Item.Get(StandardItemJournalLine."Item No.");

//         FindSalesPrice(
//           TempSalesPrice, '', '', '', '', StandardItemJournalLine."Item No.", StandardItemJournalLine."Variant Code",
//           StandardItemJournalLine."Unit of Measure Code", '', WorkDate, false, StandardItemJournalLine."Product Group Code", StandardItemJournalLine."Location Code");
//         CalcBestUnitPrice(TempSalesPrice);
//         if FoundSalesPrice or
//            not ((CalledByFieldNo = StandardItemJournalLine.FieldNo(Quantity)) or
//                 (CalledByFieldNo = StandardItemJournalLine.FieldNo("Variant Code")))
//         then
//             StandardItemJournalLine.Validate("Unit Amount", TempSalesPrice."Unit Price");
//         IsHandled := true;
//     end;


//     procedure FindSalesPrice(var ToSalesPrice: Record "Sales Price"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; ProductGroup: Code[20]; LocationCode: Code[10])
//     var
//         FromSalesPrice: Record "Sales Price";
//         TempTargetCampaignGr: Record "Campaign Target Group" temporary;
//     begin
//         /*WITH FromSalesPrice DO BEGIN
//           SETRANGE("Item No.",ItemNo);
//           SETFILTER("Variant Code",'%1|%2',VariantCode,'');
//           SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
//           IF NOT ShowAll THEN BEGIN
//             SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
//             IF UOM <> '' THEN
//               SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
//             SETRANGE("Starting Date",0D,StartingDate);
//           END;

//           ToSalesPrice.RESET;
//           ToSalesPrice.DELETEALL;

//           SETRANGE("Sales Type","Sales Type"::"All Customers");
//           SETRANGE("Sales Code");
//           CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);

//           IF CustNo <> '' THEN BEGIN
//             SETRANGE("Sales Type","Sales Type"::Customer);
//             SETRANGE("Sales Code",CustNo);
//             SETRANGE("Location Code",LocationCode);
//             CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//           END;

//           IF CustPriceGrCode <> '' THEN BEGIN
//             SETRANGE("Sales Type","Sales Type"::"Customer Price Group");
//             SETRANGE("Sales Code",CustPriceGrCode);
//             SETRANGE("Location Code",LocationCode);
//             CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//           END;

//           IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
//             SETRANGE("Sales Type","Sales Type"::Campaign);
//             IF ActivatedCampaignExists(TempTargetCampaignGr,CustNo,ContNo,CampaignNo) THEN
//               REPEAT
//                 SETRANGE("Sales Code",TempTargetCampaignGr."Campaign No.");
//                 CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//               UNTIL TempTargetCampaignGr.NEXT = 0;
//           END;
//         END;
//         */

//         //WITH FromSalesPrice DO BEGIN
//         //SAU001 Begin
//         /*
//           IF ProductGroup<>'' THEN BEGIN
//           SETRANGE("Item No.",ProductGroup);
//           //SETFILTER("Variant Code",'%1|%2',VariantCode,'');
//           SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
//           IF NOT ShowAll THEN BEGIN
//             SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
//             IF UOM <> '' THEN
//             SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
//             SETRANGE("Starting Date",0D,StartingDate);
//           END;
//           END;
//           */
//         IF ItemNo <> '' THEN BEGIN
//             FromSalesPrice.SETRANGE("Item No.", ItemNo);
//             //SETFILTER("Variant Code",'%1|%2',VariantCode,'');
//             FromSalesPrice.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);
//             IF NOT ShowAll THEN BEGIN
//                 FromSalesPrice.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
//                 IF UOM <> '' THEN
//                     FromSalesPrice.SETFILTER("Unit of Measure Code", '%1|%2', UOM, '');
//                 FromSalesPrice.SETRANGE("Starting Date", 0D, StartingDate);
//             END;


//             ToSalesPrice.RESET;
//             ToSalesPrice.DELETEALL;

//             IF CustNo <> '' THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Customer);
//                 FromSalesPrice.SETRANGE("Sales Code", CustNo);
//                 FromSalesPrice.SETRANGE("Location Code", LocationCode);
//                 CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 IF CustNo <> '' THEN BEGIN
//                     FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Customer);
//                     FromSalesPrice.SETRANGE("Sales Code", CustNo);
//                     FromSalesPrice.SETRANGE("Location Code", '');
//                     CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                 END;
//             END;
//             /*
//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//             SETRANGE("Sales Type","Sales Type"::"All Customers");
//             SETRANGE("Sales Code");
//             SETRANGE("Location Code",LocationCode);
//             CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//             SETRANGE("Sales Type","Sales Type"::"All Customers");
//             SETRANGE("Sales Code");
//             SETRANGE("Location Code",'');
//             CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//             END;
//              */

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 IF CustPriceGrCode <> '' THEN BEGIN
//                     FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
//                     FromSalesPrice.SETRANGE("Sales Code", CustPriceGrCode);
//                     FromSalesPrice.SETRANGE("Location Code", LocationCode);
//                     CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                 END;
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 IF CustPriceGrCode <> '' THEN BEGIN
//                     FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
//                     FromSalesPrice.SETRANGE("Sales Code", CustPriceGrCode);
//                     FromSalesPrice.SETRANGE("Location Code", '');
//                     CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                 END;
//             END;
//             //>>Ashwini03-06-2018
//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"All Customers");
//                 FromSalesPrice.SETRANGE("Sales Code");
//                 FromSalesPrice.SETRANGE("Location Code", LocationCode);
//                 CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"All Customers");
//                 FromSalesPrice.SETRANGE("Sales Code");
//                 FromSalesPrice.SETRANGE("Location Code", '');
//                 CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//             END;
//             //<<Ashwini 03-06-2018

//             IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Campaign);
//                 IF ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) THEN
//                     REPEAT
//                         FromSalesPrice.SETRANGE("Sales Code", TempTargetCampaignGr."Campaign No.");
//                         CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                     UNTIL TempTargetCampaignGr.NEXT = 0;
//             END;
//         END;
//         //SAU001 END


//         //ToSalesPrice.RESET;
//         IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//             /*
//             SETRANGE("Item No.",ItemNo);
//             SETFILTER("Variant Code",'%1|%2',VariantCode,'');
//             SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
//             IF NOT ShowAll THEN BEGIN
//               SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
//               IF UOM <> '' THEN
//                 SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
//               SETRANGE("Starting Date",0D,StartingDate);
//             END;
//              */
//             FromSalesPrice.SETRANGE("Item No.", ProductGroup);
//             FromSalesPrice.SETFILTER("Variant Code", '%1|%2', VariantCode, '');
//             FromSalesPrice.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);
//             IF NOT ShowAll THEN BEGIN
//                 FromSalesPrice.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
//                 IF UOM <> '' THEN
//                     FromSalesPrice.SETFILTER("Unit of Measure Code", '%1|%2', UOM, '');
//                 FromSalesPrice.SETRANGE("Starting Date", 0D, StartingDate);
//             END;


//             ToSalesPrice.RESET;
//             ToSalesPrice.DELETEALL;

//             IF CustNo <> '' THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Customer);
//                 FromSalesPrice.SETRANGE("Sales Code", CustNo);
//                 FromSalesPrice.SETRANGE("Location Code", LocationCode);
//                 CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 IF CustNo <> '' THEN BEGIN
//                     FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Customer);
//                     FromSalesPrice.SETRANGE("Sales Code", CustNo);
//                     FromSalesPrice.SETRANGE("Location Code", '');
//                     CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                 END;
//             END;
//             /*
//              IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//              SETRANGE("Sales Type","Sales Type"::"All Customers");
//              SETRANGE("Sales Code");
//              SETRANGE("Location Code",LocationCode);
//              CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//              END;

//              IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//              SETRANGE("Sales Type","Sales Type"::"All Customers");
//              SETRANGE("Sales Code");
//              SETRANGE("Location Code",'');
//              CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
//              END;
//              */

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 IF CustPriceGrCode <> '' THEN BEGIN
//                     FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
//                     FromSalesPrice.SETRANGE("Sales Code", CustPriceGrCode);
//                     FromSalesPrice.SETRANGE("Location Code", LocationCode);
//                     CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                 END;
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 IF CustPriceGrCode <> '' THEN BEGIN
//                     FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
//                     FromSalesPrice.SETRANGE("Sales Code", CustPriceGrCode);
//                     FromSalesPrice.SETRANGE("Location Code", '');
//                     CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                 END;
//             END;
//             //>>Ashwini03-06-2018
//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", "Sales Type"::"All Customers");
//                 FromSalesPrice.SETRANGE("Sales Code");
//                 FromSalesPrice.SETRANGE("Location Code", LocationCode);
//                 CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//             END;

//             IF NOT ToSalesPrice.FIND('-') THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"All Customers");
//                 FromSalesPrice.SETRANGE("Sales Code");
//                 FromSalesPrice.SETRANGE("Location Code", '');
//                 CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//             END;

//             //<<Ashwini 03-06-2018

//             IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
//                 FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Campaign);
//                 IF ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) THEN
//                     REPEAT
//                         FromSalesPrice.SETRANGE("Sales Code", TempTargetCampaignGr."Campaign No.");
//                         CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
//                     UNTIL TempTargetCampaignGr.NEXT = 0;
//             END;
//         END;
//         //END;
//     end;

//     local procedure SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
//     begin
//         PricesInCurrency := CurrencyCode2 <> '';
//         IF PricesInCurrency THEN BEGIN
//             Currency.GET(CurrencyCode2);
//             Currency.TESTFIELD("Unit-Amount Rounding Precision");
//             CurrencyFactor := CurrencyFactor2;
//             ExchRateDate := ExchRateDate2;
//         END ELSE
//             GLSetup.GET;
//     end;

//     local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[20])
//     begin
//         PricesInclVAT := PriceInclVAT2;
//         VATPerCent := VATPerCent2;
//         VATCalcType := VATCalcType2;
//         VATBusPostingGr := VATBusPostingGr2;
//     end;

//     local procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
//     begin
//         Qty := Qty2;
//         QtyPerUOM := QtyPerUoM2;
//     end;

//     local procedure CalcBestUnitPrice(var SalesPrice: Record "Sales Price")
//     var
//         BestSalesPrice: Record "Sales Price";
//         BestSalesPriceFound: Boolean;
//     begin
//         WITH SalesPrice DO BEGIN
//             FoundSalesPrice := FINDSET;
//             IF FoundSalesPrice THEN
//                 REPEAT
//                     IF IsInMinQty("Unit of Measure Code", "Minimum Quantity") THEN BEGIN
//                         ConvertPriceToVAT(
//                           "Price Includes VAT", Item."VAT Prod. Posting Group",
//                           "VAT Bus. Posting Gr. (Price)", "Unit Price");
//                         ConvertPriceToUoM("Unit of Measure Code", "Unit Price");
//                         ConvertPriceLCYToFCY("Currency Code", "Unit Price");

//                         CASE TRUE OF
//                             ((BestSalesPrice."Currency Code" = '') AND ("Currency Code" <> '')) OR
//                             ((BestSalesPrice."Variant Code" = '') AND ("Variant Code" <> '')):
//                                 BEGIN
//                                     BestSalesPrice := SalesPrice;
//                                     BestSalesPriceFound := TRUE;
//                                 END;
//                             ((BestSalesPrice."Currency Code" = '') OR ("Currency Code" <> '')) AND
//                           ((BestSalesPrice."Variant Code" = '') OR ("Variant Code" <> '')):
//                                 IF (BestSalesPrice."Unit Price" = 0) OR
//                                    (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
//                                 THEN BEGIN
//                                     BestSalesPrice := SalesPrice;
//                                     BestSalesPriceFound := TRUE;
//                                 END;
//                         END;
//                     END;
//                 UNTIL NEXT = 0;
//         END;

//         // No price found in agreement
//         IF NOT BestSalesPriceFound THEN BEGIN
//             ConvertPriceToVAT(
//               Item."Price Includes VAT", Item."VAT Prod. Posting Group",
//               Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
//             ConvertPriceToUoM('', Item."Unit Price");
//             ConvertPriceLCYToFCY('', Item."Unit Price");

//             CLEAR(BestSalesPrice);
//             BestSalesPrice."Unit Price" := Item."Unit Price";
//             BestSalesPrice."Allow Line Disc." := AllowLineDisc;
//             BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
//         END;
//         SalesPrice := BestSalesPrice;
//     end;

//     procedure FindSalesLinePriceWeb(ItemNo: Code[20]; CustNo: Code[20]): Decimal
//     var
//         decSalesPrice: Decimal;
//     begin
//         decSalesPrice := 0;
//         Item.GET(ItemNo);
//         SalesLinePriceExistsWeb(CustNo, ItemNo, FALSE);
//         //CalcBestUnitPrice(TempSalesPrice);
//         IF TempSalesPrice.FIND('-') THEN
//             REPEAT
//                 IF (decSalesPrice = 0) OR (decSalesPrice > TempSalesPrice."Unit Price") THEN
//                     decSalesPrice := TempSalesPrice."Unit Price";
//                 IF TempSalesPrice."Minimum Quantity" = 0 THEN
//                     EXIT(decSalesPrice);

//             UNTIL TempSalesPrice.NEXT = 0;
//         //IF FoundSalesPrice THEN

//         EXIT(decSalesPrice)
//     end;

//     procedure SalesLinePriceExistsWeb(CustNo: Code[20]; ItemNo: Code[20]; ShowAll: Boolean): Boolean
//     begin
//         IF Item.GET(ItemNo) THEN BEGIN
//             IF Cust.GET(CustNo) THEN BEGIN
//                 FindSalesPrice(
//                   TempSalesPrice, CustNo, '',
//                   Cust."Customer Price Group", '', ItemNo, '', Item."Sales Unit of Measure",
//                   '', TODAY, ShowAll, Item."Product Group Code", Cust."Location Code");
//                 EXIT(TempSalesPrice.FINDFIRST);
//             END;
//         END;
//         EXIT(FALSE);
//     end;

// }
