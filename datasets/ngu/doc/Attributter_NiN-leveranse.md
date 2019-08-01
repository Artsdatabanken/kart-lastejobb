Herunder har jeg gjort an oppsummering for noen av de attributter for NiN som Øyvind Bonesrønning sendte forrige uke.

SOSI kvalitetsattributter blir ved NGU forvaltet på grensene for polygoner når det er snakk om heldekkende kartlegging slik som regional berggrunnskartlegging.

På møtet her på NGU noterte jeg at leveransen til NiN fra NGU i denne omgang skulle leveres som kun polygoner. Dermed er det ikke helt rett frem å hente ut de attributter vi forvalter på polygonavgrensningene på en god måte for polygoner som jo avgrenses av flere ulike grenser. Datasettet som ligger til grunn for denne leveransen består av ca 31800 polygoner og ca 90100 linjer som avgrenser polygonene.

Når det gjelder kvalitet på berggrunn 1:250 000 så er det et datasett som er basert på en kartproduksjon fra ca 1970 -2000 og deretter blitt digitalisert. Nøyaktigheten til produktet er vanskelig å beskrive med enkelte attributt verdier. En form for produktark hvor man kan beskrive prosessen for dataene og forventet kvalitet sammen med noen metadataattributter som vi velger i ut i samspill med dere er det vi foreslår i første runde.

SOSI kvalitetsattributter: Jeg har i denne omgang til satt opp en oppsummering av det NGU har for dette originaldatasettet til denne leveransen:

Posisjonkvalitet:

- maksimaltAvvik: benyttes ikke ved NGU
- målemetode: Her er det i datasettet for grensene benyttet 8 ulike metoder som alle sammen beskriver metoden hvordan data har kommet inn til den digitale verden og ikke hvordan objektet er registrert i felt. I all hovedsak er det hva for skanningsmetode som er benyttet. Ser ikke nytteverdi av å trekke ut noe av dette til polygonene.
- målemetodeHøyde og nøyaktighetHøyde. Ikke aktuelt for dette datasettet.
- nøyaktighet: benyttes ikke for dette datasettet. NGU benytter i stedet et SOSI-attributt på grensene som heter temakvalitet. Man kan vurdere å sette en skjønnsmessig verdi på &quot;nøyaktighet&quot; som representerer at grunnlaget er tolkede grenser digitalisert fra en 1:250 000 kartserie. Som utgangspunkt kan det vurderes å benytte +/- 250m (nøyaktighet=25 000)
- synbarhet: Er ikke egnet for flatedata av tolkede berggrunnsflater. I stedet for synbarhet så benytter NGU SOSI-attributt GeolPavisningstype hvor verdiene 1-6 og 10 er benyttet på bergartsgrensene.

Nøyaktighetsklasse:

- Definisjon referer til plassering av (punkt-)objekter og gir ikke noe mer beskrivelse av hva som legges i de 4 ulike kodene. Hvis dere har en definisjon på kodene så kan vi bli enige om en felles kode for alle bergartsflatene.

Medium:

- Finnes på ca 90% av grensene men er ikke egnet å overføre til polygoner.

Opphav:

- Benyttes på grenser ved NGU. Kan ev generaliseres og overføres til polygoner.
  - Blir også innført på polygoner.

Datofelt:

- Flere ulike benyttes for dette datasetet, men til nå kun på grensene.
  - Oppdateringsdato
    - Blir også innført på flater
  - Førstedigitaliseringsdato.
    - Beskriver i stor grad digitaliseringsprosessen fra 1996-2001 sammen med noe kartlegging i senere tid.
- Også de her er vanskelige å generalisere til polygoner.

SOSI Identifikasjon.

- NGU har ikke unike id på polygoner i berggrunnsdatabasen per i dag. Det tas sikte på å innføre GUID på berggrunnsdatabasen senere i høst. Deretter blir det naturlig at datatype Identifikasjon leveres med på nye versjoner av denne leveransen.
