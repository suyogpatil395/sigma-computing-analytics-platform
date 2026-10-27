# Sigma admin playbook (how I ran the platform)

## Organisation structure
| Object | How I used it |
|---|---|
| **Teams** | one team per client brand + internal teams (Analytics, Ops) |
| **Workspaces** | one per client, linked to the client's team (members get *Can contribute* or *Can view*) |
| **Folders** | Dashboards · Data models · Drafts · Archive in every workspace |
| **User attributes** | `restaurant`, `branch`, `role` assigned at team level; user-level values only for exceptions |
| **Connections** | MySQL (POS) and Snowflake; *Can use* granted only to builders |

## Permission levels (documents & folders)
| Level | Can do |
|---|---|
| Can view | view, copy, send/schedule exports, use data models as sources |
| Can explore | everything in view + ad-hoc analysis in workbooks |
| Can edit | explore + edit, publish, share, move, delete |
| Can contribute (workspace) | create and manage own documents, explore others' |
| Can manage (workspace) | full control including access management |

## Onboarding a new client (checklist)
- [ ] Team + workspace created, folder template copied
- [ ] User attributes assigned to the team (`restaurant = <brand>`)
- [ ] Client data model published from the template (relationships, metrics, RLS column filtered to True)
- [ ] Dashboard templates duplicated and pointed at the client's model
- [ ] Reconciliation against the POS for 3 days
- [ ] Schedules and alerts (daily summary, target achieved, discrepancy)
- [ ] Users invited with the right account type; walkthrough done

## Offboarding / changes
- Remove the user from the team → access and attribute values disappear together
- Rename measures only in the data model; workbooks pick the change up automatically
- Tag stable versions of data models before big changes
