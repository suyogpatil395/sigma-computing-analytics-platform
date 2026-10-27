# Sigma formulas I use most

Sigma formulas look like spreadsheet formulas, reference columns as `[Column Name]`, and compile to warehouse SQL.

| Need | Formula |
|---|---|
| RLS by user attribute | `CurrentUserAttributeText("restaurant") = [Restaurant Name]` |
| RLS by team | `CurrentUserInTeam([Team Name])` |
| RLS by email | `[Manager Email] = CurrentUserEmail()` |
| Managers see all, others only theirs | `([Manager Email] = CurrentUserEmail()) or CurrentUserInTeam("Head Office")` |
| Map values to team names | `Switch([Region], "West", "Sales West", "East", "Sales East")` |
| Bucket bills | `If([Net Amount] >= 1500, "Large", [Net Amount] >= 600, "Medium", "Small")` |
| Month | `DateTrunc("month", [Order Ts])` |
| Days since | `DateDiff("day", [Last Order], Today())` |
| Safe divide | `Sum([Net Amount]) / Zn(CountDistinct([Order Id]))` *(check null handling for your case)* |
| Rank | `RankDense([Net Revenue])` |

Tips
- Keep RLS columns **hidden** and filter them to **True** directly on the data-model element (never via a control).
- Put shared KPIs in **metrics** on the data model, not in each workbook.
- Check generated SQL in **Query history** when a formula is slow.

Official function reference: https://help.sigmacomputing.com/docs
