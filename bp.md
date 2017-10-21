
Užpraeitą savaitgalį, vedamas netikėto impulso, nusipirkau
[3D printerį](http://us.xyzprinting.com/us_en/Product/da-Vinci-1.0-Junior).

Gavosi vienas iš tų atvejų, kai pagiringas nusiperki daiktą, kurį blaivas pirkti
vis susilaikai. Nu beveik. Iš tikro tai tiesiog pataikiau pasižiūrėti ką siūlo
Topo Centras kaip tik tuo metu, kai jie paleido 40% nuolaidą. Tai negi nepirksi?

Žodžiu, nusipirkau, ir skubiai, kol niekas iš po nosies nenukosėjo. Ir čia,
aišku, prasidėjo nuotykiai. Mat aš gi linuxistas. O mūsų poreikius, kaip
žinia, daug devaisų gamintojų mėgsta ignoruoti. Tai spėkite, ar turi tie XYZ
Printing kokio nors softo Linuxui? Aaa, a vot ir neatspėjote... Turi. Kažkokį
ten [XYZmaker](http://us.xyzprinting.com/us_en/Product/XYZmaker).

Su juo pirmiausia buvo bėdų, kad aš jo neradau. Mat jie savo internete rašo
kažką apie Linux version, bet kažkodėl tas tekstas nėra hyperlinkas ir
besiblaškant aš ilgai negalėjau rasti kur jį nudownloadinti. Vėliau radau, bet
vėliau.

Pradžioj, galvoju, kol aš ten blaškausi su tuo softu ir aplinkui, lai jis
spausdina ką nors daugiau, nei prikomplektuotas sample'as. Paprašiau Lauros duot
pavarinėti vienintelį namuose Windowsinį kompą, bet ten irgi ištiko bėdutė: tame
kompe Vista, o jų softas sukasi ant .NET 4, o .NET 4 ant Vistos jau
nebesiinstaliuoja. Snap.

Žodžiu, bevakarėjant šeštadieniui mane bandė imti panika, kad gal bus
embarrassmento vežti tą gargarą grąžinti, nes nepavyks užmegzti su juo ryšio.
Bet sekmadienį reikalai pasistūmėjo.

Pirmiausia, radau kur parsisiųsti tą XYZmaker'į ir jis man ant Linuxo pasileido.
Jėėė! Bet printerio jis man nematė. Būūū! Laimei, printeris moka spausdinti ir
iš SD kortelės. Tai jau eksportavimui printerio nematymas turėtų netrukdyti,
ane? Turėtų, bet kažkodėl trukdo. Eksportuoja, eksportuoja, progress baras
kažkoks bėga, bet galų gale failo kažkodėl nepagamina. Oh well. Reikės
pareportinti jiems šitus bugus, bet dar neprisiruošiau.

Žodžiu, fakapiškės, bet galų gale pavyko sukonstruoti toolchainą, kuris man
veikia nuo braižyklės iki printo. Tai čia aš ir baigsiu bėdavotis apie bėdas ir
papasakosiu kaip dalykai veikia, kai jau veikia.

Pradėkime nuo to, kad braižyti aš nemoku. Todėl braižymui aš naudoju
[OpenSCAD](http://www.openscad.org/). Labai geras daiktas tokiam kaip aš, nes
leidžia brėžinį aprašyti tekstu, kur aprašinėji paprastas figūras ir darai su
jomis transformacijas. Maždaug šitaip:

```
$fn=96;
difference() {
    union() {
        translate([-1.2, -1, 0]) {
            sphere(2);
        }
        translate([1.2, -1, 0]) {
            sphere(2);
        }
        rotate([-90, 0, 0]) {
            cylinder(h=8, r=1.2);
        }
        rotate([-90, 0, 0]) {
            translate([0, 0, 8]) {
                cylinder(h=1.5, r1=1.5, r2=0.5);
            }
            translate([0, 0, 7.8]) {
                cylinder(h=0.2, r=1.5);
            }
        }
    }
    translate([-4, -10, -2.5]) {
        cube([8, 20, 2]);
    }
}
```

Tada surenderini, pasižiūri ar gavosi tai, ko norėjai ir galima eksportuoti į
keletą daugiau ar mažiau paplitusių formatų.

Toliau tą formatą (aš renkuosi `.stl`) reikia paversti į printeriui suprantamą
formatą, `.gcode`[^1]. Tai daroma su slicinimo softu. Aš pirmiausia pabandžiau tokį
softą [Cura](https://ultimaker.com/en/products/cura-software) ir jis man
suveikė, tai kol kas prie jo ir likau, kito dar nebandžiau.

Cura yra kažkoks didelis softas, kuris daug visko moka, bet aš jame bukvaliai
tik atsidarau .stl failą ir išeksportuoju .gcode, daugiau nieko. Tiesa, kad
teisingai suslicinti, jam reikia žinoti printerio parametrus, o by default Cura
XYZ printerių nepalaiko, dėl to
[čia](http://www.soliforum.com/topic/15639/jr-cura-230-threedub/) susiradau
instrukcijas kaip susikonfigūruoti (dar galima rasti
[čia](http://www.thingiverse.com/thing:1915076/#files)). Dar reikėjo
[čia](https://github.com/Ultimaker/Cura/issues/847)
susirasti kur reikia pasidėti tuos printerių definitionus ant Linuxo ir mano
konkrečios Cura versijos.

So. Mažumėlę pasikrušus, turim .gcode failą. Galima spausdinti? Ne. Mat XYZ
printeriai nesupportina .gcode failų ir turi kažkokį savo proprietary formatą
`.3w`. Įdomu tai, kad tas .3w nėra joks ten proprietary formatas, o yra
lygutėliai tas pats .gcode, tik prieš tai užšifruotas AES šifru su fiksuotu
slaptažodžiu. Be menkiausios abejonės, internetai tą slaptažodį žino.

Tad sekantis žingsnis yra pasileisti https://gitlab.com/anthem/py-threedub ir
konvertuoti iš .gcode į .3w. threedub moka ne tik konvertuoti failus, bet ir
bendrauti su pačiu printeriu, ir jam netgi geriau sekasi, nei tam XYZmaker, bet
visgi ne iki galo. Kai pasiunčia printeriui job'ą, printeris kažkodėl nemato to
job'o pabaigos. threedub jau baigė siųsti ir daugiau nieko nebesiunčia, o
printeris nejaučia EOT ir rašo, kad vis dar waiting for the job. Čia irgi reikės
pasiaiškinti, gal teks kokį bugą pataisyti ar pareportinti. Bet man kol kas
pakanka failo konversijos ir spausdinimo iš SD kortelės.

Lo and behold! pirmas printas padarytas:

![bibis](/static/bibis.jpg)

Printas akivaizdžiai savievidentualiai dedikuojamas nelygioje kovoje prieš
offlainą kritusiam internetų herojui [Mykolui
Kleckui](http://www.kleckas.lt/blog/) :-)

Ir beje, tas OpenSCAD kodo gabalas kur aukščiau rodžiau, yra šito printo sorsas.
Tai galit reproducinti jeigu užpageidausit :-)

Tas printeris, beje, turi ir daugiau cirkų, bet šiai dienai gal užteks.

[^1]: Dideliausiam mano nustebimui,
    [G-code](https://en.wikipedia.org/wiki/G-code) yra ne koks nors ten
    dvimpirmam amžiuje printeriams sukurtas formatas, o gūdžiam šeštam
    dešimtmetyje MIT sukurtas formatas automatizuotiems įrankiams valdyti.
