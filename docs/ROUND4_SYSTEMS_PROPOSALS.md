# Unbearable Conditions — Round 4: Honeyhold systems proposal

**STATUS: DETAILED PROPOSALS — NOT APPROVED CANON.**
Last edited November 6, 2026. For approved facts use [APPROVED_DECISIONS.md](APPROVED_DECISIONS.md). The user asked for the economy, occupations, government, criminal justice and family schedules next. This document offers implementable mechanics and possible defaults, not compulsory decisions.

## 1. Canon constraints that govern every system

- Game: *Unbearable Conditions*, set in **Honeyhold**, independent of other bear-game universes.
- Mama: seven-year-old female brown bear. Button and Hazel: six-month-old brown bear littermates, male/female respectively. Button is emotional, extremely clingy, candid, and eager to help. Hazel is independent, inquisitive and beginning to associate with delinquent cub peers.
- Preschool: from 6 months, roughly equivalent to age 3 in human developmental terms; from 4 months nursery/social school; months 0–3 stay in the den constantly with Mama. Button and Hazel attend the same school with distinct teachers and friendships.
- **Quadrupedal movement for all bears** (adult and cub); do not make human-biped character animations. Desks, documents, seating, classrooms, beds, tools, and work stations must allow four-legged bodies.
- Grandma (Mama's mother) is primary relative caregiver; personal details undecided.
- City owns and funds Briarwood Refuge; Mama manages it. Alternate gate and refuge workdays, not both full shifts daily. No per-entrant inspection deadline; a shift-level time structure is intended, precise implementation unresolved.
- Constitutional monarchy, Queen with significant emergency powers, elected officials and competing factions; official species equality with systemic discrimination and emergency restrictions; punitive juvenile justice; politically connected Panda Mafia; competitive partisan/independent media.
- Optional rebellion path removes Mama; player chooses Button **or** Hazel, with other sibling autonomous.

## 2. Economy design (proposal)

### Separate accounts and transactions

| Account | Income | Expenditure | Constraints |
|---|---|---|---|
| Mama household | government salary, legitimate side work, gifts, benefits | rent/mortgage, groceries, heat, child supplies, debt payments | private assets/debts only |
| Briarwood public budget | scheduled city grant, designated relief grants, donations | staff wages, medical care, food, heating, beds, repairs | fiduciary obligations, audit trail and restrictions on use |
| City Treasury | taxes, tariffs, fees and bonds | schools, policing, healthcare, refuge grants, infrastructure | elected budget and Crown emergencies |
| Panda Mafia debt ledger | loan disbursement, interest, fees, forgiven debt | scheduled collections and illicit demands | may be illegal or abusive; distinct from lawfully incurred household debts |

A single consolidated money bar is prohibited. Assign each transaction an account, reason, actor, date and optional evidence. Record attempts to move restricted funds as proposed legal actions, not a silent transfer. Fraud risks follow evidence and enforcement rather than instant omniscient punishment.

### Economy loops

- Daily prices, income, discounts, local shortages and supplier reliability shift by bounded causes rather than pure RNG.
- Household food, heating, schooling supplies and treatment require cash or alternate means (subsidy, charity, temporary debt).
- Public services can be underfunded despite nominal increases: restricted grants, procurement abuse, inflation, poor contracts or deliberate political pressure.
- Reserve a readable ledger with upcoming obligations, due dates and projected cash. No unexplained surprise fines.
- Money can buy comfort, legal help, staff, transport or favors, but not erase all social or political consequences.
- Wage, cost-of-living, cub-care, and mafia-debt numbers are all **TBD**; benchmark only after a full week is playable.

### Currency names (proposals only)

A. **Crowns** — plausible national monetary unit, boring on purpose.
B. **Honey Marks** — distinctive bureaucracy-themed money without literal jars for every purchase.
C. **Denars** — in-world currency with a modest bear pun.
D. **Berry Dollars** — clear and playful, but already used in another independent bear-game universe; avoid copying cross-project canon unless deliberately approved.
E. Custom.

Recommend a simple single legal currency (Crowns or Honey Marks) plus distinct nonmonetary commodities (actual honey, food stores, fuel); **do not create arbitrary premium currency**.

## 3. Occupations, workforce, prerequisites and advancement (proposal)

Implement a career model independent of scripted character roles:

`occupation -> qualification -> application -> background/eligibility -> hiring -> schedule -> tasks -> wages -> performance -> promotion/discipline -> retirement/termination`

Each job defines skill requirements (literacy, record-keeping, first aid, craft, social ability), training pathway (school, apprenticeship, exam, certificate), legal requirements, union/affiliation, pay grade, availability, conditions, promotion tracks and risks. Prior offenses may matter but should not imply universal permanent disqualification.

| Occupation | Entry path | Day-to-day simulation | Advancement / consequences |
|---|---|---|---|
| Gate admissions clerk (Mama) | civil-service exam + screening | documents, inquiries, holds, permit decisions, reports | senior inspector, auditor, policy role; discipline |
| Refuge manager (Mama) | appointment + fiduciary duty | staffing, grants, supplies, resident cases | reappointment, replacement, audit |
| Refuge caregiver | training + safeguarding clearance | meals, comfort, baths, supervision, medical alerts | senior carer; burnout, mistakes |
| Nursery/preschool teacher | teaching qualification + safeguarding | activities, attendance, behavior, parent meetings | lead teacher; disciplinary hearings |
| School social worker | education + case accreditation | family support, assessments, referrals | trusted advocate; can also abuse discretion |
| Court clerk / legal advocate | exams, apprenticeship | dockets, filings, appeals, counsel | barrister / magistrate routes, if separate qualifications |
| Patrol officer | academy + vetting | reports, patrol, detentions, witness interviews | sergeant, investigator; corruption pressure |
| Merchant or supplier | license, capital or apprenticeship | deliveries, pricing, stock, contracts | shop owner, larger supplier |
| Journalist | portfolio/apprenticeship | interviews, documents, edits, publications | editor; lawsuits/censorship |
| Municipal laborer | trade training | repairs, heating, street safety | foreperson, union representation |
| Royal official / ministry adviser | political patronage or competitive civil service | directives, meetings, rule revision | ministerial post; faction risk |
| Underground operator | social contact / criminal recruitment | illicit demands, concealment, favors | rising leverage, violence, legal exposure |

**Do not** make species determine jobs or moral traits. If social barriers influence outcomes, model their institutional source and potential challenge.

### Political office and institutional power

- The Crown: emergency directives plus reputational and patronage leverage.
- Elected Assembly: votes on laws, services and budgets; elections and faction coalitions.
- Ministries: implement orders; may issue inconsistent circulars or partial guidance.
- Courts: process legal challenges; not magically independent of political pressure.
- Independent media: investigation and corrections; can amplify falsehoods and expose abuse.
- School, welfare, refuge and police each have distinct authority.
- A law's event record stores: source, text, enactedAt, effectiveAt, sunsetAt, emergencyAuthority, appealRights, coverage and exceptions.
- Proposed procedural check: emergency rules can require renewal, judicial review or legislative approval. Exact duration undecided.

## 4. Criminal justice and consequences (proposal)

### Separate legal stages

`allegation -> report -> evidence collection -> investigation -> detention decision -> charge -> hearing -> verdict -> sentence / release -> appeal -> correction / aftercare`

These are **different states** with authorization, dates, responsible institutions and discoverable records. A checkpoint clerk does not directly sentence someone to prison.

For juvenile cases, preserve very young cub development: a six-month-old preschooler is roughly like a three-year-old, so criminal courts for older juvenile characters need distinct age thresholds. The user approved a harsh system **overall**, not that six-month-old preschoolers must be tried like adolescents.

Possible proceedings: school discipline, child-welfare referral, detention, coerced programs, hearing, incarceration, advocacy, wrongful conviction, political prisoner case. Courts may be punitive and corrupt, but the simulation must track who made which choice.

Sentencing and punishment change observable lives: separation, attendance, family income, school contacts, wellbeing, employment opportunities, testimony, public opinion, and appeal cases. Do not collapse everything into `wanted=true`.

### Mafia system

- Distinguish debt collector, banker, front-business owner, corrupt city official, police informant, courier, and vulnerable recruit.
- No assumption that all giant pandas or red pandas are criminals; the Panda Mafia is a specific organization with specific membership.
- Mama's household debt has contractual terms, payoff options, threats, illegal pressures and evidence; paying the mafia does not necessarily end other obligations.
- Youth involvement in crime arises through individual contacts and pressure over time, especially as cubs age. No deterministic `delinquent=true` destiny.

## 5. Family, preschool, refuge and weekly schedules (proposal)

### Day structure

**Gate day:** morning family routine -> school drop-off / Grandma supervision -> shift-level gate work -> optional brief social interaction and newspaper -> home and family evening -> budget/next-day review.

**Refuge day:** morning family routine -> school / Grandma -> on-site Briarwood management + observable residents/staff -> optional city errands -> home evening -> budget.

**Rest day:** Mama can stay with cubs, attend family events, visit friends, go shopping or investigate issues. A weekly day off was mentioned by the user in the Claude conversation; exact day assignment and flexibility should be confirmed if necessary.

### Shift timer boundary

- **No timer per visitor.** Shift-end constraints only.
- Do not force a hidden two-minute countdown or constantly deplete an inspection bar while the user is reading.
- Candidate implementations: shift clock progresses on actions and phases; or a pausable real-time shift clock with generous duration. This is an **unresolved mechanic** because the user said both "flexible phases" and "shift timer only".
- When shift ends: open case finishes, is handed off, or becomes late by explicit rules; never silently erase evidence.

### School and caregiving

- Grandma handles transitions and care, but has opinions, stamina and other commitments. She can offer support, create tension, and set boundaries.
- Preschool needs separate teacher and peer graphs for Button and Hazel, even in the same institution.
- Button's attempts to help can generate competence, pride, mistakes or conflicts; his honesty can reveal real information without being infallible.
- Hazel's exploration produces knowledge, friendships, infringements and gradual risks. Her age equivalent limits what is plausible in the opening campaign.
- Family bond uses trust, warmth, resentment, attachment, promises and remembered incidents rather than one obedience meter.
- Bear physical behavior: quadrupedal walking/running/crawling; all postures and world props must suit paws, muzzles and four-legged bodies. Carrying infants and using tools require specifically authored poses; no default anthropomorphic upright walk cycles.

### Cross-system event example (illustrative, not canon plot)

A ministry cuts refuge heating aid on a day Mama is at the gate. A caregiver at Briarwood has to choose which rooms remain warm. A journalist asks Mama for comment. Grandma reports Hazel questioned a school notice about "temporary" child relocation. Mama can check the memo, raise a case or remain silent. No branch is automatically good/bad: records link everyone and carry forward.

## 6. Engineering work packages (proposed)

1. **Identity and schedule:** single persistent NPC record, age progression, location/guardian/school/occupation relations, event log and alternating days.
2. **Separate ledgers:** income/expense engine, scheduled obligations, reserve funds, restricted transfer checks; test mathematical conservation and insolvency.
3. **Government policies:** versioned law engine with authority, dates, applicability, exception procedure and case/legal distinction.
4. **Workforce model:** job registry, employment records, work schedules, wages and performance feedback, staff autonomy.
5. **School and family:** distinct teacher/peer schedules, Grandma AI, nuanced relationship memory, quadrupedal character rig.
6. **Justice cases:** event-sourced legal pipeline; appeal, sanction and custody cases, with age-dependent jurisdiction.
7. **Consequences:** newspaper claims linked to evidence, resident visibility, social consequences, history-aware authored events.
8. **Playable week test:** two gate days, two refuge days, one rest period and ongoing family/home scenes across seven days (exact weekly rotation still to design); avoid inventing unearned availability numbers.
9. **Campaign:** scale toward 25+ days after the connected first-week milestone proves causal behavior.

### QA invariants

- No public refuge transaction silently spends Mama's private money, or vice versa.
- Age 0–3 months implies den-dependent routine; at 4+ nursery eligible; at 6+ preschool eligible. Applies by actual character age.
- Every bear character uses quadrupedal movement, not a human biped rig.
- Gate denial does not rewrite legal guardianship, and refuge admission does not automatically grant citizenship.
- Criminal conviction follows a court authority event; a gate clerk cannot independently issue sentence.
- Newspaper publication is a claim by an identifiable outlet, not objective truth.
- A saved game retains Grandma, class/school, relations, law versions, case status, income, inventory, and both cub histories.
- Rebellion continuation switches main controlled sibling and preserves the other as a simulated autonomous NPC.

## 7. Round 4 decision targets (unanswered)

1. Currency system/name.
2. Economic difficulty and risk of insolvency.
3. Household housing tenure and debt mechanics.
4. How Mama obtained two public jobs and what institution can discipline/fire her.
5. Exact Queen emergency power oversight and elections.
6. Factions/parties and changes in law.
7. Court authority, juvenile age thresholds and appeal chances.
8. Preschool schedule and Grandma's residence.
9. Shift clock implementation.
10. Occupational access/education and post-rebellion control.

These are design choices, **not blockers for source archival work**. Source provenance and stable original tests still need to be recovered and rerun before feature changes.
