report 60001 "Cleanup Utility"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                ERROR('Process is under construction!');
                IF NOT CONFIRM(TEXT001, FALSE) THEN
                    EXIT;

                Win.OPEN('##1#########');
                i += 1;
                Win.UPDATE(1, i);
                Cust.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CustInvoiceDisc.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CustLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Vend.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VendorInvoiceDisc.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VendorLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ITM.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchaseHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchaseLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                GLRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                UserTimeRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                GenJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BOMComponent.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                GLBudgetEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemVendor.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesShipmentHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesShipmentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesInvoiceHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesInvoiceLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesCrMemoHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesCrMemoLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchRcptHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchRcptLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchInvHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchInvLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchCrMemoHdr.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchCrMemoLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResCapacityEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                JobLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Job.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardSalesLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardPurchaseLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                JobJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ShiptoAddress.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                OrderAddress.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReasonCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResourceRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                JobRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RequisitionLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VATStatementLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TariffNumber.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                IntrastatJnlLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankAccount.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankAccountLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CheckLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankAccReconciliation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankAccReconciliationLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankAccountStatement.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ExtendedTextHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ExtendedTextLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PhysInventoryLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CustomerBankAccount.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VendorBankAccount.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VATAmountLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReservationEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                EntrySummary.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemApplicationEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemApplicationEntryHistory.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DetailedCustLedgEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DetailedVendorLedgEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ChangeLogEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ApprovalEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ApprovalCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedApprovalEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedApprovalCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                OverdueNotificationEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                JobQueueLogEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DimensionSetEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VATRateChangeLogEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardGeneralJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardItemJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CertificateofSupply.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DOPaymentCreditCard.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DOPaymentTransLogEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CashFlowAccountComment.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CashFlowForecastEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CashFlowManualRevenue.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CashFlowManualExpense.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AssemblyHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AssemblyLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AssemblyCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedAssemblyHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedAssemblyLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Contact.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ContactAltAddress.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesHeaderArchive.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesLineArchive.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchaseHeaderArchive.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchaseLineArchive.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchCommentLineArchive.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesCommentLineArchive.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Employee.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AlternativeAddress.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Qualification.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                EmployeeQualification.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Relative.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                EmployeeRelative.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                EmployeeAbsence.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                HumanResourceCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                EmploymentContract.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Confidential.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ConfidentialInformation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                HRConfidentialCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemVariant.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemUnitofMeasure.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionOrder.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderComponent.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderRoutingLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderCapacityNeed.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderRoutingTool.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderRoutingPersonnel.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderRtngQltyMeas.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderRtngCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProdOrderCompCmtLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PlanningErrorLog.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                UnplannedDemand.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                InventoryPageData.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TimelineEvent.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TimelineEventChange.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FixedAsset.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FALedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DepreciationBook.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FADepreciationBook.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FAAllocation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FARegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FAJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FAReclassJournalLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                MaintenanceLedgerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TransferHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TransferLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TransferShipmentHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TransferShipmentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TransferReceiptHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TransferReceiptLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                InventoryCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseRequest.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseActivityHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseActivityLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RegisteredWhseActivityHdr.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RegisteredWhseActivityLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ValueEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AvgCostAdjmtEntryPoint.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                GLItemLedgerRelation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceItemLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceDocumentLog.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Loaner.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                LoanerEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FaultArea.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DetailedCustLedgEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemEntryRelation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ValueEntryRelation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReturnReceiptHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReturnReceiptLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BinContent.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SymptomCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FaultReasonCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FaultCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResolutionCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FaultResolCodesRlship.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FaultAreaSymptomCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RepairStatus.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceShelf.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceEMailQueue.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceDocumentRegister.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceItem.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceItemComponent.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceItemLog.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TroubleshootingHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TroubleshootingLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceOrderAllocation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResourceLocation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WorkHourTemplate.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SkillCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResourceSkill.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceZone.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ResourceServiceZone.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceContractLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceContractHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ContractChangeLog.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ContractGainLossEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FiledServiceContractHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FiledContractLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ContractServiceDiscount.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceShipmentItemLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceShipmentHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceShipmentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceInvoiceHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceInvoiceLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceCrMemoHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceCrMemoLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardServiceCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardServiceLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardServiceItemGrCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServPriceAdjustmentDetail.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ServiceLinePriceAdjmt.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SerialNoInformation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                LotNoInformation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemTrackingComment.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WhseItemEntryRelation.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WhseItemTrackingLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReturnReason.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReturnShipmentHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ReturnShipmentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                "Returns-RelatedDocument".DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesPrice.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesLineDiscount.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchasePrice.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PurchaseLineDiscount.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesPriceWorksheet.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                CampaignTargetGroup.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AnalysisLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemAnalysisViewEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseEmployee.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseReceiptHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseReceiptLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedWhseReceiptHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedWhseReceiptLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseShipmentHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WarehouseShipmentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedWhseShipmentHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedWhseShipmentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                "WhsePut-awayRequest".DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WhsePickRequest.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WhseWorksheetLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                "WhseInternalPut-awayHeader".DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                "WhseInternalPut-awayLine".DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WhseInternalPickHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                WhseInternalPickLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Bin.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BaseCalendarChange.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemIdentifier.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ADCSUser.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                DimensionsFieldMap.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                MyCustomer.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                MyVendor.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                MyItem.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                AccountIdentifier.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankRecHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankRecLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BankCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedBankRecHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PostedBankRecLine.DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // "BankRecSub-line".DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // DepositHeader.DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // PostedDepositHeader.DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // PostedDepositLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                TrackingNo.DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // Specsheet.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PaymentFutureOldInv.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemSpecContents.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemSpecCleaningCode.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                VendorRequestSheet.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                BoxMaster.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                MultiplePayment.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PackingHeader.DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // SpecSheetFiberContents.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PackingItemList.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                StandardComment.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemCustomer.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesPersonCommision.DELETEALL;

                // i += 1;
                // Win.UPDATE(1, i);
                // MAS2yrsales.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PackingLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                MailDetail.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                HandHeld.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Stop.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Scrap.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RoutingHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RoutingLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ManufacturingCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionBOMHeader.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionBOMLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                Family.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                FamilyLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                RoutingCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionBOMCommentLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionBOMVersion.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionMatrixBOMLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ProductionMatrixBOMEntry.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                SalesPlanningLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PlanningComponent.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                PlanningRoutingLine.DELETEALL;

                i += 1;
                Win.UPDATE(1, i);
                ItemAvailabilityLine.DELETEALL;


                Win.CLOSE;
                MESSAGE(TEXT002);
            end;

            trigger OnPreDataItem()
            begin
                ERROR('Process is under construction!');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Win: Dialog;
        i: Integer;
        Cust: Record Customer;
        CustInvoiceDisc: Record "Cust. Invoice Disc.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendorInvoiceDisc: Record "Vendor Invoice Disc.";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ITM: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        SalesCommentLine: Record "Sales Comment Line";
        GLRegister: Record "G/L Register";
        ItemRegister: Record "Item Register";
        UserTimeRegister: Record "User Time Register";
        GenJournalLine: Record "Gen. Journal Line";
        ItemJournalLine: Record "Item Journal Line";
        BOMComponent: Record "BOM Component";
        GLBudgetEntry: Record "G/L Budget Entry";
        CommentLine: Record "Comment Line";
        ItemVendor: Record "Item Vendor";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        IncomingDocument: Record "Incoming Document";
        ResCapacityEntry: Record "Res. Capacity Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        Job: Record Job;
        StandardSalesLine: Record "Standard Sales Line";
        StandardPurchaseLine: Record "Standard Purchase Line";
        ResLedgerEntry: Record "Res. Ledger Entry";
        ResJournalLine: Record "Res. Journal Line";
        JobJournalLine: Record "Job Journal Line";
        ShiptoAddress: Record "Ship-to Address";
        OrderAddress: Record "Order Address";
        ReasonCode: Record "Reason Code";
        ResourceRegister: Record "Resource Register";
        JobRegister: Record "Job Register";
        RequisitionLine: Record "Requisition Line";
        VATStatementLine: Record "VAT Statement Line";
        TariffNumber: Record "Tariff Number";
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
        BankAccount: Record "Bank Account";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccountStatement: Record "Bank Account Statement";
        BankAccountStatementLine: Record "Bank Account Statement Line";
        ExtendedTextHeader: Record "Extended Text Header";
        ExtendedTextLine: Record "Extended Text Line";
        PhysInventoryLedgerEntry: Record "Phys. Inventory Ledger Entry";
        CustomerBankAccount: Record "Customer Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        VATAmountLine: Record "VAT Amount Line";
        ReservationEntry: Record "Reservation Entry";
        EntrySummary: Record "Entry Summary";
        ItemApplicationEntry: Record "Item Application Entry";
        ItemApplicationEntryHistory: Record "Item Application Entry History";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ChangeLogEntry: Record "Change Log Entry";
        ApprovalEntry: Record "Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
        PostedApprovalEntry: Record "Posted Approval Entry";
        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
        OverdueNotificationEntry: Record "Overdue Approval Entry";
        JobQueueLogEntry: Record "Job Queue Log Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
        VATRateChangeLogEntry: Record "VAT Rate Change Log Entry";
        StandardGeneralJournalLine: Record "Standard General Journal Line";
        StandardItemJournalLine: Record "Standard Item Journal Line";
        CertificateofSupply: Record "Certificate of Supply";
        DOPaymentCreditCard: Record "DO Payment Credit Card";
        DOPaymentTransLogEntry: Record "DO Payment Trans. Log Entry";
        CashFlowAccountComment: Record "Cash Flow Account Comment";
        CashFlowForecastEntry: Record "Cash Flow Forecast Entry";
        CashFlowManualRevenue: Record "Cash Flow Manual Revenue";
        CashFlowManualExpense: Record "Cash Flow Manual Expense";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        AssemblyCommentLine: Record "Assembly Comment Line";
        PostedAssemblyHeader: Record "Posted Assembly Header";
        PostedAssemblyLine: Record "Posted Assembly Line";
        Contact: Record Contact;
        ContactAltAddress: Record "Contact Alt. Address";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesLineArchive: Record "Sales Line Archive";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        PurchaseLineArchive: Record "Purchase Line Archive";
        PurchCommentLineArchive: Record "Purch. Comment Line Archive";
        SalesCommentLineArchive: Record "Sales Comment Line Archive";
        Employee: Record Employee;
        AlternativeAddress: Record "Alternative Address";
        Qualification: Record Qualification;
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record Relative;
        EmployeeRelative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        HumanResourceCommentLine: Record "Human Resource Comment Line";
        EmploymentContract: Record "Employment Contract";
        Confidential: Record Confidential;
        ConfidentialInformation: Record "Confidential Information";
        HRConfidentialCommentLine: Record "HR Confidential Comment Line";
        ItemVariant: Record "Item Variant";
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ProductionOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderCapacityNeed: Record "Prod. Order Capacity Need";
        ProdOrderRoutingTool: Record "Prod. Order Routing Tool";
        ProdOrderRoutingPersonnel: Record "Prod. Order Routing Personnel";
        ProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
        ProdOrderCommentLine: Record "Prod. Order Comment Line";
        ProdOrderRtngCommentLine: Record "Prod. Order Rtng Comment Line";
        ProdOrderCompCmtLine: Record "Prod. Order Comp. Cmt Line";
        PlanningErrorLog: Record "Planning Error Log";
        UnplannedDemand: Record "Unplanned Demand";
        InventoryPageData: Record "Inventory Page Data";
        TimelineEvent: Record "Timeline Event";
        TimelineEventChange: Record "Timeline Event Change";
        FixedAsset: Record "Fixed Asset";
        FALedgerEntry: Record "FA Ledger Entry";
        DepreciationBook: Record "Depreciation Book";
        FADepreciationBook: Record "FA Depreciation Book";
        FAAllocation: Record "FA Allocation";
        FARegister: Record "FA Register";
        FAJournalLine: Record "FA Journal Line";
        FAReclassJournalLine: Record "FA Reclass. Journal Line";
        MaintenanceLedgerEntry: Record "Maintenance Ledger Entry";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptLine: Record "Transfer Receipt Line";
        InventoryCommentLine: Record "Inventory Comment Line";
        WarehouseRequest: Record "Warehouse Request";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        RegisteredWhseActivityHdr: Record "Registered Whse. Activity Hdr.";
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
        ValueEntry: Record "Value Entry";
        AvgCostAdjmtEntryPoint: Record "Avg. Cost Adjmt. Entry Point";
        GLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        ServiceHeader: Record "Service Header";
        ServiceItemLine: Record "Service Item Line";
        ServiceDocumentLog: Record "Service Document Log";
        Loaner: Record Loaner;
        LoanerEntry: Record "Loaner Entry";
        FaultArea: Record "Fault Area";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ItemEntryRelation: Record "Item Entry Relation";
        ValueEntryRelation: Record "Value Entry Relation";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        BinContent: Record "Bin Content";
        WarehouseEntry: Record "Warehouse Entry";
        WarehouseRegister: Record "Warehouse Register";
        SymptomCode: Record "Symptom Code";
        FaultReasonCode: Record "Fault Reason Code";
        FaultCode: Record "Fault Code";
        ResolutionCode: Record "Resolution Code";
        FaultResolCodesRlship: Record "Fault/Resol. Cod. Relationship";
        FaultAreaSymptomCode: Record "Fault Area/Symptom Code";
        RepairStatus: Record "Repair Status";
        ServiceShelf: Record "Service Shelf";
        ServiceRegister: Record "Service Register";
        ServiceEMailQueue: Record "Service Email Queue";
        ServiceDocumentRegister: Record "Service Document Register";
        ServiceItem: Record "Service Item";
        ServiceItemComponent: Record "Service Item Component";
        ServiceItemLog: Record "Service Item Log";
        TroubleshootingHeader: Record "Troubleshooting Header";
        TroubleshootingLine: Record "Troubleshooting Line";
        ServiceOrderAllocation: Record "Service Order Allocation";
        ResourceLocation: Record "Resource Location";
        WorkHourTemplate: Record "Work-Hour Template";
        SkillCode: Record "Skill Code";
        ResourceSkill: Record "Resource Skill";
        ServiceZone: Record "Service Zone";
        ResourceServiceZone: Record "Resource Service Zone";
        ServiceContractLine: Record "Service Contract Line";
        ServiceContractHeader: Record "Service Contract Header";
        ContractChangeLog: Record "Contract Change Log";
        ContractGainLossEntry: Record "Contract Gain/Loss Entry";
        FiledServiceContractHeader: Record "Filed Service Contract Header";
        FiledContractLine: Record "Filed Contract Line";
        ContractServiceDiscount: Record "Contract/Service Discount";
        ServiceShipmentItemLine: Record "Service Shipment Item Line";
        ServiceShipmentHeader: Record "Service Shipment Header";
        ServiceShipmentLine: Record "Service Shipment Line";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        StandardServiceCode: Record "Standard Service Code";
        StandardServiceLine: Record "Standard Service Line";
        StandardServiceItemGrCode: Record "Standard Service Item Gr. Code";
        ServPriceAdjustmentDetail: Record "Serv. Price Adjustment Detail";
        ServiceLinePriceAdjmt: Record "Service Line Price Adjmt.";
        SerialNoInformation: Record "Serial No. Information";
        LotNoInformation: Record "Lot No. Information";
        ItemTrackingComment: Record "Item Tracking Comment";
        WhseItemEntryRelation: Record "Whse. Item Entry Relation";
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
        ReturnReason: Record "Return Reason";
        ReturnShipmentHeader: Record "Return Shipment Header";
        ReturnShipmentLine: Record "Return Shipment Line";
        "Returns-RelatedDocument": Record "Returns-Related Document";
        SalesPrice: Record "Sales Price";
        SalesLineDiscount: Record "Sales Line Discount";
        PurchasePrice: Record "Purchase Price";
        PurchaseLineDiscount: Record "Purchase Line Discount";
        SalesPriceWorksheet: Record "Sales Price Worksheet";
        CampaignTargetGroup: Record "Campaign Target Group";
        AnalysisLine: Record "Analysis Line";
        ItemAnalysisViewEntry: Record "Item Analysis View Entry";
        WarehouseEmployee: Record "Warehouse Employee";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        "WhsePut-awayRequest": Record "Whse. Put-away Request";
        WhsePickRequest: Record "Whse. Pick Request";
        WhseWorksheetLine: Record "Whse. Worksheet Line";
        "WhseInternalPut-awayHeader": Record "Whse. Internal Put-away Header";
        "WhseInternalPut-awayLine": Record "Whse. Internal Put-away Line";
        WhseInternalPickHeader: Record "Whse. Internal Pick Header";
        WhseInternalPickLine: Record "Whse. Internal Pick Line";
        Bin: Record Bin;
        BaseCalendarChange: Record "Base Calendar Change";
        ItemIdentifier: Record "Item Identifier";
        ADCSUser: Record "ADCS User";
        DimensionsFieldMap: Record "Dimensions Field Map";
        MyCustomer: Record "My Customer";
        MyVendor: Record "My Vendor";
        MyItem: Record "My Item";
        AccountIdentifier: Record "Account Identifier";
        BankRecHeader: Record "Bank Acc. Reconciliation";
        BankRecLine: Record "Bank Acc. Reconciliation Line";
        BankCommentLine: Record "Bank Comment Line";
        PostedBankRecHeader: Record "Posted Bank Rec. Header";
        PostedBankRecLine: Record "Posted Bank Rec. Line";
        // "BankRecSub-line": Record "Bank Rec. Sub-line";
        // DepositHeader: Record "Deposit Header";
        // PostedDepositHeader: Record "Posted Deposit Header";
        // PostedDepositLine: Record "Posted Deposit Line";
        TrackingNo: Record "Tracking No.";
        // Specsheet: Record "Spec sheet";
        PaymentFutureOldInv: Record "Payment Future Old Inv";
        ItemSpecContents: Record "Item Spec Contents";
        ItemSpecCleaningCode: Record "Item Spec Cleaning Code";
        VendorRequestSheet: Record "Vendor Request Sheet";
        BoxMaster: Record "Box Master";
        MultiplePayment: Record "Multiple Payment";
        PackingHeader: Record "Packing Header";
        //SpecSheetFiberContents: Record "Spec Sheet Fiber Contents";
        PackingItemList: Record "Packing Item List";
        StandardComment: Record "Standard Comment";
        ItemCustomer: Record "Item Customer";
        SalesPersonCommision: Record "SalesPerson Commision";
        //MAS2yrsales: Record "MAS 2yr sales";
        PackingLine: Record "Packing Line";
        MailDetail: Record "Mail Detail";
        HandHeld: Record HandHeld;
        Stop: Record Stop;
        Scrap: Record Scrap;
        RoutingHeader: Record "Routing Header";
        RoutingLine: Record "Routing Line";
        ManufacturingCommentLine: Record "Manufacturing Comment Line";
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
        Family: Record Family;
        FamilyLine: Record "Family Line";
        RoutingCommentLine: Record "Routing Comment Line";
        ProductionBOMCommentLine: Record "Production BOM Comment Line";
        ProductionBOMVersion: Record "Production BOM Version";
        ProductionMatrixBOMLine: Record "Production Matrix BOM Line";
        ProductionMatrixBOMEntry: Record "Production Matrix  BOM Entry";
        SalesPlanningLine: Record "Sales Planning Line";
        PlanningComponent: Record "Planning Component";
        PlanningRoutingLine: Record "Planning Routing Line";
        ItemAvailabilityLine: Record "Item Availability Line";
        TEXT001: Label 'Do you want to delete data?';
        TEXT002: Label 'All Table data deleted';
}

