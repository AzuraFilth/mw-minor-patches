@echo off
REM ============================================================================
REM  BCOM <-> "Seyda Neen - Damp Little Squat" compatibility patch
REM
REM  Fixes the load error:
REM    Unable to find referenced object "Rent_Arille_Door" in script AST_rentArille
REM
REM  Root cause: the original --match "Seyda Neen" batch deleted Arrille's
REM  Tradehouse (which holds the persistent door Rent_Arrille_Door) but left
REM  BCOM's script AST_rentArille, whose "Rent_Arrille_Door"->unlock line then
REM  cannot resolve at load. This patch also removes that orphaned script and
REM  its NPC, deletes the conflicting cells by coordinate (catching the unnamed
REM  -1,-9 cell), removes BCOM's landscape there, and strips the matching
REM  pathgrids from BCOM_pathgrid_reset.ESP.
REM ============================================================================

REM 1) Remove BCOM's Seyda Neen interior cells (full handoff to DLS).
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --interior --id "Seyda Neen" "Beautiful cities of Morrowind.esp"

REM 2) Remove BCOM's Seyda Neen exterior cells by coordinate (catches the unnamed -1,-9).
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --exterior --id "\(-2, -10\)" --id "\(-2, -9\)" --id "\(-1, -9\)" "Beautiful cities of Morrowind.esp"

REM 3) Remove BCOM's landscape for those cells (avoid terrain seams).
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --type LAND --id "\(-2, -10\)" --id "\(-2, -9\)" --id "\(-1, -9\)" "Beautiful cities of Morrowind.esp"

REM 4) Remove BCOM's exterior pathgrids for those cells (BCOM main has pgrds at -2,-9 and -2,-10).
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --type pgrd --id "\(-2, -10\)" --id "\(-2, -9\)" --id "\(-1, -9\)" "Beautiful cities of Morrowind.esp"

REM 5) Delete the broken rent script ("Rent_Arille_Door")
REM     --exact-id anchors the match (^id$) so only these exact records are removed.
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --type NPC_ --exact-id "RP_SN_publican" --sub-match "AST_rentArille" "Beautiful cities of Morrowind.esp"
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --type SCPT --exact-id "AST_rentArille" "Beautiful cities of Morrowind.esp"

REM 6) Remove BCOM's re-injected Seyda Neen pathgrids from the pathgrid-reset plugin.
tes3cmd delete --backup-dir tes3cmdbck --hide-backups --type pgrd --id "\(-2, -10\)" --id "\(-2, -9\)" --id "\(-1, -9\)" "BCOM_pathgrid_reset.esp"

pause
