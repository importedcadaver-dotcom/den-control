# Unbearable Conditions — Round 5 proposals (historical reference)

**STATUS: ROUND 5 ANSWERED.** This was written **before** the Round 5 votes. The user's *latest revised* Round 5 answers are authoritative and in [APPROVED_DECISIONS.md](APPROVED_DECISIONS.md). **Do not treat unselected proposals here as canon**; see explicit corrections below. 
Created November 6, 2026. This is an implementable worldbuilding proposal based on the user's approved Rounds 1–4. See [APPROVED_DECISIONS.md](APPROVED_DECISIONS.md) before introducing or rejecting any system. Names, district counts, job ratios, and numerical values below are working proposals.

## Round 5 results superseding this draft

- Approved **seven** connected districts; the seven **names** in this document remain provisional.
- Approved bear-majority demographics with smaller cat/red panda minorities and mixed neighborhoods with sharply unequal resources.
- Royal family is **brown bear**, and the Queen specifically is **Kodiak brown bear**.
- Two major parties: welfare/civil liberties vs royal authority/security; names and individual members still proposed.
- Careers can be entered via education, apprenticeships, patronage and experience depending on role.
- **12–20** deeply developed recurring characters (not this draft's 30–60 full NPC proposal). Background cast may remain lighter.
- Grandma enjoys deliberate **emotional cruelty, discomfort neglect, threats and hazardous humiliation/hazing**. Mama **already knows she is mean**, but relies on her for work/money; changing ordinary childcare requires a **substantial story**, though emergency intervention should be possible.
- Preschool B for now (observable visits and reports), C later (direct playable cub perspective).
- **Continuous calendar aging** with abilities unlocked as age advances; **no default narrative time skips**.
- Juvenile law uses offense-specific ages and emergency exceptions.
- **Button and Hazel can hate, fight, and hurt one another emotionally or physically**, with real relationships and injury consequences. **Bears show emotional tears.**

## 1. Invariants established by the user

- Honeyhold is a constitutional monarchy. Queen can indefinitely suspend most laws during a declared emergency. Two major political parties and smaller civic movements exist.
- Public legal equality of species coexists with prejudice, unequal economic power, discriminatory policies and emergency restrictions.
- Mama, 7-year-old brown bear, voluntarily acquired two jobs: government gate admissions officer and publicly funded Briarwood Refuge manager. Fixed weekly cycle: **gate / refuge / gate / refuge / gate / refuge / off**.
- The national currency is **Honey Marks (HM)**. Household and refuge books are detailed; citywide market conditions use lighter background simulation. Panda Mafia loan has a starting principal, interest, installments and escalating collection pressure (exact rates not canon).
- Button and Hazel are six-month-old quadrupedal brown bear littermates, preschool level roughly comparable to human 3-year-olds. Both are in the same school, different teachers/peer groups, for a **structured half-day**; nursery from 4 months and den-dependence from 0–3 months.
- **Button**: boy, clingy, outwardly emotional, candid without filter, loves helping Mama, **prefers indoors and constructed/modern conveniences to outdoor nature**.
- **Hazel**: girl, independent, curious, questioning, beginning to mix with delinquent peers, **hates being told what to do**.
- **Grandma**: Mama's mother, in her own nearby residence, regular non-school caregiver. **She is mean to the cubs and both justifiably hate her.** Do not portray their hatred as unreasonable or retcon her into a harmless sweet grandmother.
- The checkpoint has **one generous real-time shift clock**, not a per-visitor timer. Pause during reading/menus; settings let the player disable shift timing altogether. Real-time animations/UI timers and simulation-time scheduling must be distinguished.
- Severe late-game rebellion path can kill Mama; player **chooses Button or Hazel** as main successor while other child persists autonomously. Fictional violent scene remains narrative/cutscene based.

## 2. Proposed layout: connected places, not generic menus

**Working city districts** (names and count provisional):

| District | Built environment | Predominant opportunities and pressures | Gameplay reason to visit |
|---|---|---|---|
| **Gateward** | Rain-stained arches, inspection queue, freight slips, hostel | Border workers, travelers, temporary residents | Work, documents, appeals, witness accounts |
| **Crown Heights** | Elevated galleries, royal chambers, ministerial buildings | Patronage, political influence, affluent households | Petition, hearings, ceremonies, rebellion path |
| **Hearthmarket** | Shops and workshops around a heated communal hall | Commerce, supply contracts, rumors, credit | Buy supplies, find jobs, investigate merchants |
| **Old Burrows** | Dense old tunnel homes, shared child-care spaces | Expensive repairs, close neighbors, eviction | Personal contacts, housing cases, school peers |
| **Foundry Reach** | Furnaces, public heating pipes, freight caves | Trades, labor disputes, utility shortages | Heating, workplace accidents, labor politics |
| **Briarwood Fringe** | Woodland threshold, refuge grounds, public gardens | Refuge care, donations, welfare services | Mama's refuge work, watch and help residents |
| **School Steps** | Preschool and nursery complex, family services offices | Teachers, classmates, school records and social care | Pickups, parent meetings, cub social life |

These should be spatially legible on an original city map; no real-world geolocation required. Short travel scenes and optional fast travel can coexist.

Locations need persistent residents, operating hours, occupancy, ongoing states, inventories and histories. Opening a location should show who actually arrived there and what they were doing before Mama entered. No spontaneous recreation of NPCs with new identities.

## 3. Class and species: use mechanisms, not biological destiny

**Species admitted by existing concept:** bears (including multiple species), red pandas, domestic and big cats. The user's specific city proportions are undecided; do not copy proportions from other projects. Keep every bear quadrupedal. Cats/red pandas should be represented with their own consistent animal anatomy as well.

Class may affect:
- Housing access, heating reliability, schooling resources and medical services;
- Legal representation, opportunities, police scrutiny and speed of permits;
- Transport, documentation support and informal networks;
- Exposure to criminal exploitation and access to financial credit.

Avoid automatic criminal propensity or assigned professions by species. A discriminatory rule needs a traceable policy source or institutional practice; economic effects should be observable.

**Superseded population proposal:** The user selected **12–20 deeply simulated recurring characters**, not the old 30–60 target. This draft's earlier proposal was 30–60 persistent named/important NPCs, plus a larger pool of lightweight background residents with stable IDs where they appear repeatedly. This number is an implementation target only; measure performance and adjust. NPC records should not multiply automatically simply because UI scenes switch.

## 4. Government and two-party structure

**Proposed ideological tension**, not moral labels:

- **Civic Solidarity Party** (placeholder): funds schools and public services, supports checks on emergency authority, but internal factions dispute taxes, border policy and public unions.
- **Crown Stability Party** (placeholder): prioritizes security, royal prerogatives and business confidence, but includes both honest public servants and corrupt patronage networks.
- Smaller groups: organized labor, student/parent advocates, merchants' guild, royal loyalists, independent journalists, local rights organizations, clandestine revolutionaries.

No party is inherently right or evil; issue-specific coalitions matter. A party may deliver a genuine benefit while passing a harmful law.

### Live law process

Each statute/order stores a unique ID, promulgating actor, time of effect, applicability, exceptions, source documents, enforcement guideline, judicial state, and historical versions. Executive emergency decrees can suspend most law indefinitely until rescinded, overruled through a mechanism the user later approves, or a change of regime. No implied mandatory sunset.

**Player-visible chain:** morning newspaper reports a new rule -> ministry bulletin appears -> actual inspection rulebook changes -> individual families face consequences -> lawsuits/protests change public record -> staff and politicians respond. Separate official text, media framing, Mama's evidence and actual truth.

## 5. Occupations and institutions

### Major NPC career record

Fields: `employer_id`, `role_id`, `contract_status`, `qualification_ids`, `schedule`, `pay`, `promotion_eligibility`, `performance`, `disciplinary_events`, `skills`, `training_history`, `work_relations`. Adult characters can switch occupations for grounded reasons, not reroll into random careers.

**Proposed substantial recurring cast (roles only, names intentionally deferred):**

1. **Grandma** — nearby caregiver; mean to both cubs, own home, social connections and reasons to be unavailable. Her exact treatment, beliefs and motivation are a design question, not an excuse for mistreatment.
2. **Button's preschool teacher** — responds to emotional outbursts, honesty, good intentions, classroom assistance.
3. **Hazel's preschool teacher** — responds to questioning, refusals, curiosity, and peer trouble; not necessarily a villain.
4. **Preschool administrator** — manages reporting, discipline, funding and family-service referrals.
5. **Hazel's first independent-minded friend** — an actual preschool-age character, not automatically a gang criminal.
6. **An older child or older sibling connected to local delinquent circles** — potential indirect influence and welfare risk, not a predetermined plot.
7. **Gate supervisor** — controls Mama's evaluations, legal exceptions and career path.
8. **Refuge senior caregiver** — works while Mama is at the gate; competent enough to run routines but capable of disagreement.
9. **Refuge intake/medical worker** — makes care assessments and can uncover concealed problems.
10. **Mafia debt representative** — recurring lender/collector with a distinct schedule and objectives.
11. **Government-affiliated newspaper editor or reporter** — has institutional sources and pressure.
12. **Independent reporter** — may expose corruption, make mistakes, or pursue a personal agenda.
13. **Police investigator / juvenile justice liaison** — recurring with cases and procedural powers.
14. **Local merchant / supplier** — price negotiations, inventory, school and refuge supply links.

**Implementation staging:** do not attempt to simulate every occupation in Honeyhold at full fidelity immediately. First build the above occupations as an open role registry, then add employers/qualifications/promotion rules used by recurring NPCs.

## 6. Grandma and cub home life as a genuine gameplay system

The user's input explicitly makes Grandma a **bad caregiver**, not merely a strict one. Respect this in character motivation, cub memories, dialogue, observation and decisions.

Possible measurable relations:
- `trust[mama]`, `trust[grandma]`, `attachment[mama]`, `resentment[grandma]`;
- `school_comfort`, `home_security`, `autonomy_need`, `social_reputation`;
- adult `caregiver_reliability`, `stress`, `discipline_style`, `concealment`, `availability`.

Do not assume the same reaction to Grandma from both cubs:
- Button may vocalize distress, ask Mama to stay home, cling to the door, or expose cruel remarks in front of teachers.
- Hazel may argue, refuse, hide from Grandma, seek outside playmates, or keep private notes/objects. She hates directives generally, yet her hostility toward Grandma is specifically **justified by Grandma's mistreatment**.

**Player agency must include trying to understand what happened and changing arrangements.** Potential reactions: question Grandma, talk privately to each cub, investigate school/care records, set boundaries, seek substitute care, rearrange work, involve social services or allies. There should be real cost and logistical consequences without trapping the children indefinitely in a single forced abusive-care storyline. Not all options can succeed quickly, and Grandma cannot be treated as automatically redeemed.

**Superseded:** Round 5 confirms Grandma enjoys cruelty/humiliating dares, Mama knows she is mean, and alternatives require a substantial storyline; details of specific cases and alternate arrangements remain to design.

## 7. A sample week of causal simulation (illustrative, not an approved storyline)

**Day 1: Gate.** Newspaper announces an emergency visa screening order. Mama processes a family with complete papers, learns a parent seeks treatment, and records a provisional follow-up. Grandma collects Button and Hazel after half-day preschool; both dread the pickup.

**Day 2: Refuge.** The family requests temporary shelter. Refuge heating budget cannot cover every room. Senior staff argue for triage criteria; Mama can inspect facts, allocate money, or seek support. Hazel tells school friends that adults lie about fairness.

**Day 3: Gate.** The earlier family returns with an updated document. A reporter asks why an exception was denied. Button gets into conflict at preschool after bluntly speaking about Grandma.

**Day 4: Refuge.** A supplier raises prices, citing a utility shortage. Independent media disputes the government account. Hazel refuses an instruction at preschool and is put on a behavior report; Grandma criticizes her at pickup.

**Day 5: Gate.** Mama sees a person connected to the supplier and the Mafia collector. Missing an installment could trigger a new demand. A possible conflict of interest arises.

**Day 6: Refuge.** One resident may be relocated; a staff member challenges Mama's decision. Grandma cannot automatically be assumed safe or trustworthy; Mama can pursue alternative after-school care.

**Day 7: Off.** Visit the cubs, follow unresolved problems and plan the next week. No work shift; consequences still unfold.

These events require case branching, persistent individuals and world state. Do **not** treat them as preapproved authored scenes.

## 8. Measurable next design/engineering decisions

- District count and exploration model; city transport and housing class.
- Species mix and how rights/inequalities vary by institution.
- Policies and personalities of the two major parties; royal family species and specific power limitations.
- Grandma's exact mistreatment and what Mama knows; credible alternate-care routes.
- Preschool peer network and first week of observable school behavior.
- How careers and trade qualifications progress; major NPC cast size.
- Evidence and discipline systems: school reports, juvenile justice thresholds, and media corrections.
- What the on/off shift timer changes (shift end only, not NPC age or case facts), and how effects carry across enabled/disabled runs.
- Early progression goal: complete seven-day life with a recurring gate family, refuge placement, household friction and political/financial consequences.

**Technical note:** this file contains narrative and engineering proposals only. Neither the original Godot project nor the Claude HTML has yet been imported into GitHub as a working merged build. Do not report any code feature as completed based on this document.
