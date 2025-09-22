// codeunit 50222 CreateReservEntry_Ext
// {
//     Permissions = TableData "Reservation Entry" = rim;

//     trigger OnRun()
//     begin
//     end;

//     [EventSubscriber(ObjectType::Codeunit, codeunit::"Create Reserv. Entry", 'OnAfterCreateRemainingReservEntry', '', false, false)]
//     local procedure OnAfterCreateRemainingReservEntry(OldReservEntry: Record "Reservation Entry"; LastReservEntry: Record "Reservation Entry")
//     begin
//         LastReservEntry."Quality Grade" := OldReservEntry."Quality Grade";
//         LastReservEntry."Dylot No." := OldReservEntry."Dylot No.";
//     end;

// }
