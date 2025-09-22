query 50014 CustomerContactDeatils
{
    Caption = 'Customer Contact Deatils';
    QueryType = Normal;
    elements
    {
        dataitem(Customer; Customer)
        {
            column(Customer_No; "No.") { }
            column(Customer_Name; Name) { }
            column(Customer_Search_Name; "Search Name") { }
            column(Customer_Salesperson_Code; "Salesperson Code") { }
            column(Customer_Last_Date_Modified; "Last Date Modified") { }
            column(Customer_Address; Address) { }
            column(Customer_Address_2; "Address 2") { }
            column(Customer_Country_Region_Code; "Country/Region Code") { }
            column(Customer_City; City) { }
            column(Customer_County; County) { }
            column(Customer_Post_Code; "Post Code") { }
            column(Customer_Phone_No; "Phone No.") { }
            column(Customer_Primary_Contact_No; "Primary Contact No.") { }
            column(Customer_Contact; Contact) { }
            column(Customer_Customer_Price_Group; "Customer Price Group") { }
            column(Customer_Payment_Method_Code; "Payment Method Code") { }
            column(Customer_Location_Code; "Location Code") { }
            dataitem(ContactBusinessRelation; "Contact Business Relation")
            {
                DataItemLink = "No." = Customer."No.";
                dataitem(Contact; Contact)
                {
                    DataItemLink = "Company No." = ContactBusinessRelation."Contact No.";
                    column(Contact_No; "No.") { }
                    column(Contact_Type; Type) { }
                    column(Contact_Search_Name; "Search Name") { }
                    column(Contact_Name; Name) { }
                    column(Contact_Company_No; "Company No.") { }
                    column(Contact_Company_Name; "Company Name") { }
                    column(Contact_EMail; "E-Mail") { }
                    column(Contact_First_Name; "First Name") { }
                    column(Contact_Middle_Name; "Middle Name") { }
                    column(Contact_Surname; Surname) { }
                    column(Contact_Address; Address) { }
                    column(Contact_Address_2; "Address 2") { }
                    column(Contact_City; City) { }
                    column(Contact_County; County) { }
                    column(Contact_Post_Code; "Post Code") { }
                    column(Contact_Country_Region_Code; "Country/Region Code") { }
                    column(Contact_Phone_No; "Phone No.") { }
                    column(Contact_Salesperson_Code; "Salesperson Code") { }
                    column(Contact_Last_Date_Modified; "Last Date Modified") { }
                }
            }
        }
    }
}

