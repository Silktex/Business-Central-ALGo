query 50012 SalesOrderDeatils
{
    Caption = 'Sales Order Deatils';
    QueryType = Normal;

    elements
    {
        dataitem(SalesHeader; "Sales Header")
        {
            column(No; "No.") { }
            column(Sell_to_Contact_No; "Sell-to Contact No.") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_County; "Ship-to County") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }
            column(Shipping_Agent_Service_Code; "Shipping Agent Service Code") { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(External_Document_No; "External Document No.") { }
            column(Location_Code; "Location Code") { }
            column(Sell_to_Phone_No; "Sell-to Phone No.") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(Tracking_No; "Tracking No.") { }
            column(Package_Tracking_No; "Package Tracking No.") { }
            column(AddressValidated; AddressValidated) { }
            column(Residential; Residential) { }
            dataitem(Location; Location)
            {
                DataItemLink = Code = SalesHeader."Location Code";

                column(LoacationCode; Code) { }
                column(LoacationPost_Code; "Post Code") { }
                column(LoacationName; Name) { }
                column(LoacationAddress; Address) { }
                column(LoacationAddress_2; "Address 2") { }
                column(LoacationCity; City) { }
                column(LoacationCounty; County) { }
                column(LoacationCountry_Region_Code; "Country/Region Code") { }
                column(LoacationPhone_No; "Phone No.") { }
                column(LoacationE_Mail; "E-Mail") { }
                column(LoacationUPS_Account; "UPS Account") { }
                column(LoacationUPS_User_Name; "UPS User Name") { }
                column(LoacationUPS_Password; "UPS Password") { }
                column(LoacationLicense_Number; "License Number") { }
                column(LoacationFedEx_Account; "FedEx Account") { }
                column(LoacationCertificate_Number; "Certificate Number") { }
                column(LoacationFedex_Meter_No; "Fedex Meter No") { }
                column(LoacationFedex_Password; "Fedex Password") { }
                column(LoacationStamps_Username; "Stamps Username") { }
                column(LoacationStamps_Password; "Stamps Password") { }
                column(LoacationStamps_Authentication_Id; "Stamps Authentication Id") { }



                dataitem(WarehouseShipmentLine; "Warehouse Shipment Line")
                {
                    DataItemLink = "Source No." = SalesHeader."No.";
                    DataItemTableFilter = "Line No." = filter(10000);

                    dataitem(WarehouseShipmentHeader; "Warehouse Shipment Header")
                    {
                        DataItemLink = "No." = WarehouseShipmentLine."No.";

                        column(WarehouseShipmentNo; "No.") { }
                        column(WarehouseShipmentCOD_Amount; "COD Amount") { }
                        column(WarehouseShipmentCash_On_Delivery; "Cash On Delivery") { }
                        column(WarehouseShipmentCharges_Pay_By; "Charges Pay By") { }
                        column(WarehouseShipmentGross_Weight; "Gross Weight") { }
                        column(WarehouseShipmentInsurance_Amount; "Insurance Amount") { }
                        column(WarehouseShipmentNo_of_Boxes; "No. of Boxes") { }
                        column(WarehouseShipmentShipping_Account_No; "Shipping Account No.") { }
                        column(WarehouseShipmentSignature_Required; "Signature Required") { }
                        column(WarehouseShipmentThird_Party; "Third Party") { }
                        column(WarehouseShipmentThird_Party_Account_No; "Third Party Account No.") { }
                        column(WarehouseShipmentBox_Code; "Box Code") { }
                        dataitem(BoxMaster; "Box Master")

                        {
                            DataItemLink = "Box Code" = WarehouseShipmentHeader."Box Code";

                            column(BoxMasterBoxCode; "Box Code") { }
                            column(BoxMasterHeight; Height) { }
                            column(BoxMasterWidth; Width) { }
                            column(BoxMasterLength; Length) { }
                        }
                    }
                }


            }
        }

        // dataitem(SalesLine; "Sales Line")
        // {
        //     DataItemLink = "Document No." = SalesHeader."No.";
        //     column(Document_No; "Document No.") { }
        //     column(Description; Description) { }
        //     column(Line_Amount; "Line Amount") { }
        //     column(Line_No; "Line No.") { }
        //     column(Outstanding_Quantity; "Outstanding Quantity") { }
        //     column(Quantity; Quantity) { }
        //     column(SalesLine_No; "No.") { }
        //     column(Item_Category_Code; "Item Category Code") { }
        //     column(Unit_Price; "Unit Price") { }
        //     column(Unit_of_Measure; "Unit of Measure") { }
        //     column(Promised_Delivery_Date; "Promised Delivery Date") { }
        //     column(Requested_Delivery_Date; "Requested Delivery Date") { }
        // }
    }
}

