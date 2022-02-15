globals ; values that are global in the simulation
[
orange-count              ; t carriers
grey-count              ; wildtypes
plotting-t
plotting-w
total-litters
file-name
file-name-geno-smart
file-name-dispersal
file-name-mortality
file-name-local-densities
file-name-litters
count-t
count-w
count-tt
  count-all
max-ticks-orig
mean-matings
median-matings
  var-matings
  sd-matings
min-turtles-r1
mean-turtles-r1
max-turtles-r1
mean-turtles-r3
max-turtles-r3
P_inc
P_full

  t-homozygous-viability-tmp
;tm-death-by-age
;tm-death-by-density
;
;  tf-death-by-age
;tf-death-by-density
;
;  wm-death-by-age
;wm-death-by-density
;
;  wf-death-by-age
;wf-death-by-density

]

turtles-own ; variables that each agent carries
[
t-status            ;
sex                 ;
t-mating
w-mating
matings
fecundity
closest-mate
pup-count
birth-tick
age
disperser
w-dispersal-modifier
w2-dispersal-modifier
t-dispersal-modifier
t2-dispersal-modifier
t-fathers
w-fathers
t-fathers-disp
t2-fathers-disp
t-w-fathers-disp
w-fathers-disp
w2-fathers-disp
inherited-from
density-immune
approached-males


t-fathers-dispersed
w-fathers-dispersed

random-father


w-dispersal-density-threshold
w2-dispersal-density-threshold
t-dispersal-density-threshold
t2-dispersal-density-threshold

t-fathers-disp-dd
t2-fathers-disp-dd
t-w-fathers-disp-dd
w-fathers-disp-dd
w2-fathers-disp-dd

]

patches-own ;variables each patch carries
[
density
t-density
density-immune-patch
immune-since
last-max-turtles
carrying-capacity
  last-turtle-count
  mean-matings-on-patch
  pre-dispersal-count
  male-turtles-here
  turtlesonpatch
]


to setup ; which functions to start on initialization of a new simulation



if t-starting-frequency = 1
  [
    set end-with-t? False
  ]

clear-output
setup-experiment
setup-patches



end

to setup-patches
ask patches ;; make each patch do the following
[  set density-immune-patch false
    set carrying-capacity random-normal-cc
    ;set plabel carrying-capacity

]


end






to setup-experiment


set max-ticks-orig max-ticks ; alternative variable for dynamically extended simulation lengths, not used in Runge et al.
print word "setup run " behaviorspace-run-number
clear-patches
clear-turtles
clear-all-plots
clear-ticks

; create file names for files that track the simulation
set file-name word "-" behaviorspace-run-number
set file-name-geno-smart word file-name "-geno-smart.csv"
set file-name-dispersal word file-name "-dispersal.csv"
set file-name-mortality word file-name "-mortality.csv"
set file-name-local-densities word file-name "-local-densities.csv"
set file-name-litters word file-name "-reports-litters.csv"





set total-litters 0

set P_inc -1
  ifelse (start_with_mutation = True)
  [
    set P_full 1.0
  ]
  [
    set P_full -1
  ]


    fill-in-turtles starting-number t-starting-frequency 1




if (t-starting-frequency = 1) ;starting frequency of +/t of 1% is converted into / represents 0% (otherwise above method breaks by dividing by 0
[
  ask turtles with [t-status = 1 or t-status = 2]
  [
    die
  ]
]
reset-ticks
end

to fill-in-turtles [howmany tfreq tkind]
  let previous_Pfull P_full
    ifelse (start_with_mutation = True)
  [
    set P_full 1.0
  ]
  [
    set P_full -1
  ]
  let whocompare 0
  if(count turtles > 0)
  [
    set whocompare max [who] of turtles
  ]
  create-turtles howmany
[
  setxy random-pxcor random-pycor      ; random location for each starting mouse
  ifelse (who - whocompare) < (howmany / (100 / tfreq)) ; respect the desired starting frequency of +/t
    [
      ifelse (who - whocompare) < (howmany / (200 / tfreq)) ;then each sex/genotype combination gets its share
      [
        ;set color lput 125 extract-rgb 29
        ;set shape "default" ; male
        set t-status tkind
        set sex "m"
        set age 1
        set disperser false
        set w-dispersal-modifier 1.0
        set t-dispersal-modifier 1.0
        set density-immune false
        if tkind = 1
        [

        if (evolve-dispersal = true) [ set w-dispersal-modifier dispersal-mod-evolver-start set t-dispersal-modifier dispersal-mod-evolver-start ]
        if (loci = 2) [ set w-dispersal-density-threshold dispersal-dd-evolver-start set t-dispersal-density-threshold dispersal-dd-evolver-start ]

        set w2-dispersal-modifier "NA"
        set w2-dispersal-density-threshold "NA"



        set t2-dispersal-modifier "NA"
        set t2-dispersal-density-threshold "NA"




        ]

        if tkind = 2
        [

        if (evolve-dispersal = true) [ set t2-dispersal-modifier dispersal-mod-evolver-start set t-dispersal-modifier dispersal-mod-evolver-start ]
        if (loci = 2) [ set t2-dispersal-density-threshold dispersal-dd-evolver-start set t-dispersal-density-threshold dispersal-dd-evolver-start ]

        set w2-dispersal-modifier "NA"
        set w2-dispersal-density-threshold "NA"



        set w-dispersal-modifier "NA"
        set w-dispersal-density-threshold "NA"




        ]


      ]
      [
        ;set color lput 125 extract-rgb 29
        ;set shape "pentagon" ; female
        set t-status tkind
        set sex "f"
        set t-mating 0
        set w-mating 0
        set matings 0
        set fecundity fecundity-global + random fecundity-random
        set age 1
        set disperser false
        set w-dispersal-modifier 1.0
        set t-dispersal-modifier 1.0

        set t-fathers []
        set w-fathers []
        set t-fathers-disp []
        set t2-fathers-disp []
        set t-w-fathers-disp []
        set w-fathers-disp []
        set w2-fathers-disp []
        set density-immune false






        set random-father 0






        set t-fathers-disp-dd []
        set t2-fathers-disp-dd []
        set t-w-fathers-disp-dd []
        set w-fathers-disp-dd []
        set w2-fathers-disp-dd []



        if tkind = 1
        [

        if (evolve-dispersal = true) [ set w-dispersal-modifier dispersal-mod-evolver-start set t-dispersal-modifier dispersal-mod-evolver-start ]
        if (loci = 2) [ set w-dispersal-density-threshold dispersal-dd-evolver-start set t-dispersal-density-threshold dispersal-dd-evolver-start ]

        set w2-dispersal-modifier "NA"
        set w2-dispersal-density-threshold "NA"



        set t2-dispersal-modifier "NA"
        set t2-dispersal-density-threshold "NA"




        ]

        if tkind = 2
        [

        if (evolve-dispersal = true) [ set t2-dispersal-modifier dispersal-mod-evolver-start set t-dispersal-modifier dispersal-mod-evolver-start ]
        if (loci = 2) [ set t2-dispersal-density-threshold dispersal-dd-evolver-start set t-dispersal-density-threshold dispersal-dd-evolver-start ]

        set w2-dispersal-modifier "NA"
        set w2-dispersal-density-threshold "NA"



        set w-dispersal-modifier "NA"
        set w-dispersal-density-threshold "NA"




        ]



      ]

    ]
    [
      ifelse (who - whocompare) < (howmany - (howmany / (200 / tfreq)))
      [
        ;set color lput 125 extract-rgb 9
        ;set shape "default"
        set t-status 0
        set sex "m"
        set age 1
        set disperser false
        set w-dispersal-modifier 1.0
        set w2-dispersal-modifier 1.0
        if (evolve-dispersal = true) [ set w-dispersal-modifier dispersal-mod-evolver-start set w2-dispersal-modifier dispersal-mod-evolver-start ]
        if (loci = 2) [ set w-dispersal-density-threshold dispersal-dd-evolver-start  set w2-dispersal-density-threshold dispersal-dd-evolver-start]
        set density-immune false

        set t-dispersal-modifier "NA"
        set t-dispersal-density-threshold "NA"



        set t2-dispersal-modifier "NA"
        set t2-dispersal-density-threshold "NA"



      ]
      [
        ;set color lput 125 extract-rgb 9
        ;set shape "pentagon"
        set t-status 0
        set sex "f"
        set t-mating 0
        set w-mating 0
        set matings 0
        set fecundity fecundity-global + random fecundity-random
        set age 1
        set disperser false
        set w-dispersal-modifier 1.0
        set w2-dispersal-modifier 1.0
        if (evolve-dispersal = true) [ set w-dispersal-modifier dispersal-mod-evolver-start set w2-dispersal-modifier dispersal-mod-evolver-start]
        if (loci = 2) [ set w-dispersal-density-threshold dispersal-dd-evolver-start set w2-dispersal-density-threshold dispersal-dd-evolver-start]
        set t-fathers []
        set w-fathers []
        set t-fathers-disp []
        set t2-fathers-disp []
        set t-w-fathers-disp []
        set w-fathers-disp []
        set w2-fathers-disp []
        set density-immune false













        set t-fathers-disp-dd []
        set t2-fathers-disp-dd []
        set t-w-fathers-disp-dd []
        set w-fathers-disp-dd []
        set w2-fathers-disp-dd []



        set t-dispersal-modifier "NA"
        set t-dispersal-density-threshold "NA"



        set t2-dispersal-modifier "NA"
        set t2-dispersal-density-threshold "NA"



      ]
    ]




  set size 1                   ; easier to see
    set hidden? true
    check-for-mutations
]


  set P_full previous_Pfull

end



to-report random-normal-cc
  let temp round random-normal cc-mean cc-sd
  if (temp > (cc-mean + (2 * cc-sd)))
  [
    set temp (cc-mean + (2 * cc-sd))
  ]
  if (temp < (cc-mean - (2 * cc-sd)))
  [
    set temp (cc-mean - (2 * cc-sd))
  ]
  if (temp < 0)
  [
    set temp 0
  ]
  report temp
end

to-report random-incremental-cc [cc]
  let temp round random-normal cc cc-sd-incr
  if (temp > (cc-mean + (2 * cc-sd)))
  [
    set temp random-incremental-cc cc
  ]
  if (temp < (cc-mean - (2 * cc-sd)))
  [
    set temp random-incremental-cc cc
  ]
  if (temp < 0)
  [
    set temp random-incremental-cc cc
  ]
  report temp
end

to go ; one turn = one run of this function "go"
    ;update the mutation probabilities
 ; if (only_phenotypic_range = True)
 ; [
 ;   set t-effect "dominant"
 ; ]
  if (ticks > 5)
  [
    ifelse (P_evo_decrease = true)
    [
      ifelse (ticks-when-t-comes-in > 0)
      [


        ifelse (ticks >= ticks-when-t-comes-in)
        [
          ;set P_inc P_inc_set / (1 + ((ticks - ticks-when-t-comes-in) * (1 / ((max-ticks - ticks-when-t-comes-in) / 50))))
          set P_inc P_inc_set - ((ticks - ticks-when-t-comes-in) * (((P_inc_set - P_inc_final) / (max-ticks - ticks-when-t-comes-in))))
        ]
        [
          ;set P_inc P_inc_set / (1 + ((ticks) * (1 / ((ticks-when-t-comes-in) / 50))))
          set P_inc P_inc_set - ((ticks) * ((P_inc_set - P_inc_final) / (ticks-when-t-comes-in)))
        ]
      ]
      [
        set P_inc P_inc_set - ((ticks) * ((P_inc_set - P_inc_final) / (max-ticks)))
      ]

      ifelse (P_full_exists = true)
      [
        set P_full P_full_set / (1 + (ticks * (1 / 5000)))
      ]
      [
        set P_full -1
      ]
    ]

    [

      set P_inc P_inc_set
      ifelse (P_full_exists = true)
      [
        set P_full P_full_set
      ]
      [
        set P_full -1
      ]


    ]
]

  if(ticks = ticks-when-t-comes-in and ticks-when-t-comes-in > 0)
  [

      ifelse(switch-turtles = TRUE)
      [
        switch-turtles-now
      ]
      [
        fill-in-turtles 1000 100 1
      ]

  set end-with-t? true
  ]

if (shuffle-patches = true and shuffle-patches-timing != 0) ; patch densities keep being re-shuffled every x turns
[
  if (ticks mod shuffle-patches-timing = 0)
  [
      if (incremental-shuffle = False)
      [
        ask patches [set carrying-capacity random-normal-cc]
      ]
      if (incremental-shuffle = True)
        [
          ask patches [set carrying-capacity random-incremental-cc carrying-capacity]
        ]
     ]
]












  if (density-death = false)
  [
    ask patches
  [
    set pre-dispersal-count count turtles-here
  ]

  ]






ifelse (only-juvenile-dispersal = true) ; true in Runge et al.
[
  ask turtles with [age = 1][

    disperse ; dispersal procedure
  ]
]
[
  ask turtles [
    disperse
  ]
]





 if (ticks mod 1000 = 0 and patches-report = TRUE) [ifelse ticks = 0 [report-patches TRUE] [report-patches FALSE]] ; every 1k ticks, report on the patches
 ; if(update-males-after-every-female = FALSE) [update-turtles-list]
mate ; mating procedure
if(ticks mod 100 = 0)
  [
if (count turtles with [sex = "f" and age >= 1] > 10)
    [
      set mean-matings mean([matings] of turtles with [sex = "f" and age >= 1]) ; tracking the mean number of matings for the live viewer
      set sd-matings standard-deviation([matings] of turtles with [sex = "f" and age >= 1]) ; tracking the mean number of matings for the live viewer
    ]
  ]




  ;set median-matings median([matings] of turtles with [sex = "f" and age >= 1]) ; tracking the mean number of matings for the live viewer
if (ticks mod 1000 = 0 and matings-report = TRUE) [ifelse ticks = 0 [report-matings TRUE] [report-matings FALSE]] ; every 1000 ticks report on the matings that are happening in one tick

litter ; birth procdure


death ; density-independent mortality procedure
patch-density-death ; density-dependent mortality procedure



increment-age

set count-t count turtles with [t-status = 1]
set count-tt count turtles with [t-status = 2]
set count-w count turtles with [t-status = 0]
set count-all count-t + count-tt + count-w
  if (patch-fidelity = true) [show-density] ; visuals for the live viewer
if ((count-t + count-tt) = 0 or (count-w + count-t) = 0) and (end-with-t? = true)
[print (word "tick " ticks ": t died out.") stop] ; end simulation if t dies out

if (count-all = 0) [stop] ; or if all mice are dead










if (ticks mod 100 = 0) [output-print (word "Run " behaviorspace-run-number ": " ticks "/" max-ticks "")] ; incomplete tracking in the terminal





if (ticks = max-ticks)
[
  if(extended-disadvantage-adaptation = false) ; false in Runge et al.
  [stop]

  if(extended-disadvantage-adaptation = true)
  [
    set max-ticks max-ticks + max-ticks-orig
    set w-advantage w-advantage + 0.01
  ]
]
smart-report-current-genotypes ; genotype tracking

;set max-turtles-r3 max [count turtles in-radius 3] of turtles
;set mean-turtles-r3 mean [count turtles in-radius 3] of turtles
;set max-turtles-r1 max [count turtles in-radius 1] of turtles
;set mean-turtles-r1 mean [count turtles in-radius 1] of turtles
;set min-turtles-r1 min [count turtles in-radius 1] of turtles
tick
end

to update-turtles-list

  ask patches
  [
    set male-turtles-here turtles-here with [sex = "m" and age >= 1]
    ;set female-turtles-here turtles-here with [sex = "f"]
  ]

end


to show-density ; live tracking visuals
ask patches
[
  ifelse (count turtles-here > 0)
  [
    set density (count turtles-here with [t-status >= 1] / count turtles-here)
    if (density = 0) [set pcolor 4]
    if (density > 0 and density < 0.3) [set pcolor 28]
    if (density >= 0.3 and density < 0.5) [set pcolor 25]
    if (density > 0.5) [set pcolor 22]
  ]
  [
    set pcolor white
  ]
]
end


to disperse

  ifelse (dispersal-density-updated-after-each-dispersal = true)
  [
    set turtlesonpatch count turtles-here
  ]
  [
    set turtlesonpatch pre-dispersal-count
  ]


ifelse (evolve-dispersal = true) ; true in Runge et al.

[



  if t-status = 1 or t-status = 2


  [
    ;default is dominant to always LET the variables.. do not change this, netlogo parser does not like all lets behind ifs
    let t-disp-mod t-dispersal-modifier ;a
    let t-disp-dens-t t-dispersal-density-threshold ;b

    if t-effect = "additive" and t-status = 1
      [
        set t-disp-mod (t-dispersal-modifier + w-dispersal-modifier) / 2 ;a
        if loci = 2
        [
          set t-disp-dens-t (t-dispersal-density-threshold + w-dispersal-density-threshold) / 2 ;b
        ]

      ]


    if t-status = 2
      [
        set t-disp-mod (t-dispersal-modifier + t2-dispersal-modifier) / 2
        if loci = 2
        [
        set t-disp-dens-t (t-dispersal-density-threshold + t2-dispersal-density-threshold) / 2
        ]

        if t-effect = "dominant"
        [

          set t-disp-mod t-dispersal-modifier
          set t-disp-dens-t t-dispersal-density-threshold


        ]

      ]

    ; new formula:

    let chance 0



    ; old formula:





        set chance t-disp-mod

        if (new-density-dependent-dispersal = TRUE)
        [




          if (loci = 1)
          [

             set chance t-disp-mod


          ]


          if (loci = 2)
          [


                set chance t-disp-mod + t-disp-dens-t * turtlesonpatch

          ]




        ]




    if (random-float 1 <= chance) ; disperser!

    [




      disperse-movement ; the actual dispersal

      set disperser true





      if (random-float 1 <= dispersal-cost) [ ; dispersal mortality
        die
      ]
    ]
  ]
  if t-status = 0
    [
	
	; default is an unused additive mechanic, which is overwritten below
      let w-disp-mod (w-dispersal-modifier + w2-dispersal-modifier) / 2
      let w-disp-dens-w "NA"
      if loci = 2 [
      set w-disp-dens-w (w-dispersal-density-threshold + w2-dispersal-density-threshold) / 2
      ]

      if (t-effect = "dominant")
      [
        set w-disp-mod w-dispersal-modifier ;note that there is a random placement at the initialization of each mouse, such that choosing one chromosome here means that one is chosen at random.
        set w-disp-dens-w w-dispersal-density-threshold
      ]

      let chance 0
      ;new formula:





        set chance w-disp-mod

        if (new-density-dependent-dispersal = TRUE)
        [


          if (loci = 1)
          [
            set chance w-disp-mod



          ]

          if (loci = 2)
          [




                set chance w-disp-mod + w-disp-dens-w * turtlesonpatch

          ]


        ]




      if (random-float 1 <= chance)
        [


          disperse-movement
          set disperser true


          if (random-float 1 <= dispersal-cost) [

            die
            ]
        ]
    ]

]
[

  print "Warning: Dispersal disabled outside of evolution simulations. Just turn evolution rates to zero instead."

]






end

to disperse-movement



    random-but-new-patch


end

to random-but-new-patch

  let newx random-pxcor
  let newy random-pycor
  ifelse ([patch-here] of self = [self] of patch newx newy)
  [
    random-but-new-patch
  ]
  [
    setxy newx newy
  ]

end

to switch-turtles-now

  ask n-of (round ((count turtles) / 2)) turtles
       [

        set t-status 1


        set t-dispersal-modifier w2-dispersal-modifier
        set t-dispersal-density-threshold w2-dispersal-density-threshold

        set w2-dispersal-modifier "NA"
        set w2-dispersal-density-threshold "NA"



        set t2-dispersal-modifier "NA"
        set t2-dispersal-density-threshold "NA"



        ]

end

to t-ind-mating [active-turtle]

  ; mating with a t male



    let whois self
    set matings matings + 1

    if [t2-dispersal-modifier] of turtle active-turtle = "NA" or t-homozygous-fertile = true
    [




      ; in the following, the t sires and their loci values are put into lists
      ; this is done so that the loci values of subsequently dead fathers can still be accessed (dead agents are deleted)



      if (t-mating = 0) ; need to create list if no t-matings yet this turn
      [
        set t-fathers []
        set t-fathers-disp []
        set t2-fathers-disp []
        set t-w-fathers-disp []
        set t-fathers-disp-dd []
        set t2-fathers-disp-dd []
        set t-w-fathers-disp-dd []
        set t-fathers-dispersed []
      ]



      set t-fathers lput active-turtle t-fathers

      set t-fathers-disp  lput [t-dispersal-modifier] of turtle active-turtle t-fathers-disp
      set t2-fathers-disp  lput [t2-dispersal-modifier] of turtle active-turtle t2-fathers-disp
      set t-w-fathers-disp  lput [w-dispersal-modifier] of turtle active-turtle t-w-fathers-disp

      if [t2-dispersal-modifier] of turtle active-turtle = "NA" and [w-dispersal-modifier] of turtle active-turtle = "NA" [print "t is not t nor t2"] ; bug detection, now obsolete

      set t-fathers-dispersed lput [disperser] of turtle active-turtle t-fathers-dispersed

      set t-w-fathers-disp-dd lput [w-dispersal-density-threshold] of turtle active-turtle t-w-fathers-disp-dd
      set t-fathers-disp-dd lput [t-dispersal-density-threshold] of turtle active-turtle t-fathers-disp-dd
      set t2-fathers-disp-dd lput [t2-dispersal-density-threshold] of turtle active-turtle t2-fathers-disp-dd




      set t-mating t-mating + 1
    ]


end

to w-ind-mating [active-turtle]



    let whois self

    set matings matings + 1

    ifelse (w-mating = 0) [

      set w-fathers []
      set w-fathers (list active-turtle)

      set w-fathers-disp []
      set w-fathers-disp  (list [w-dispersal-modifier] of turtle active-turtle)

      set w2-fathers-disp []
      set w2-fathers-disp  (list [w2-dispersal-modifier] of turtle active-turtle)

      set w-fathers-disp-dd []
      set w-fathers-disp-dd  (list [w-dispersal-density-threshold] of turtle active-turtle)

      set w2-fathers-disp-dd []
      set w2-fathers-disp-dd  (list [w2-dispersal-density-threshold] of turtle active-turtle)



      set w-fathers-dispersed []
      set w-fathers-dispersed (list [disperser] of turtle active-turtle)


    ]

    [


      set w-fathers lput active-turtle w-fathers
      set w-fathers-disp  lput [w-dispersal-modifier] of turtle active-turtle w-fathers-disp
      set w2-fathers-disp  lput [w2-dispersal-modifier] of turtle active-turtle w2-fathers-disp
      set w-fathers-dispersed lput [disperser] of turtle active-turtle w-fathers-dispersed
      set w-fathers-disp-dd lput [w-dispersal-density-threshold] of turtle active-turtle w-fathers-disp-dd
      set w2-fathers-disp-dd lput [w2-dispersal-density-threshold] of turtle active-turtle w2-fathers-disp-dd
    ]
    set w-mating w-mating + 1


end

to individual-mating [male-genotype active-turtle]




        set approached-males 0

        ask [male-turtles-here] of patch-here
        [

          ;if (random-float 1 <= (1 / (1 + ln(1 + ([approached-males] of turtle active-turtle * approach-alpha)))))
          if ([approached-males] of turtle active-turtle = 0 or random-float 1 < approach-alpha) ; < because 0 should disable polyandry
          [


            if(t-status >= 1)
      [
            let male-turtle who

            ask turtle active-turtle
            [

        t-ind-mating male-turtle
            ]

      ]

      if(t-status = 0)
      [
        let male-turtle who

            ask turtle active-turtle
            [

        w-ind-mating male-turtle
            ]

      ]

          ]

          ask turtle active-turtle
            [
            set approached-males approached-males + 1
            ]


        ]







end

to mate
ask turtles with [sex = "f" and age >= 1]
[

  let active-turtle who

 ; if(update-males-after-every-female = TRUE) [
      ask patch-here [
      set male-turtles-here turtles-here with [sex = "m" and age >= 1]
      ]
 ;   ]






  ifelse t-status >= 1




  [



    individual-mating "t" active-turtle


  ]



  [

    individual-mating "w" active-turtle


  ]







]

end


; now come pretty redundant functions to create new mice

to new-t-male
;set color lput 125 extract-rgb 29
;set shape "default" ; male
set t-status 1
set sex "m"

set age 0
set disperser false
set density-immune false

set w2-dispersal-modifier "NA"
set w2-dispersal-density-threshold "NA"



set t2-dispersal-modifier "NA"
set t2-dispersal-density-threshold "NA"









end

to new-t-female

;set color lput 125 extract-rgb 29
;set shape "pentagon" ; female
set t-status 1
set sex "f"
set t-mating 0
set w-mating 0
set matings 0
set fecundity fecundity-global + random fecundity-random

set age 0
set disperser false
set t-fathers []

set w-fathers []
set t-fathers-disp []
set t2-fathers-disp []
set t-w-fathers-disp []
set w-fathers-disp []
set w2-fathers-disp []
set density-immune false














set t-fathers-disp-dd []
set t2-fathers-disp-dd []
set t-w-fathers-disp-dd []
set w-fathers-disp-dd []
set w2-fathers-disp-dd []

set w2-dispersal-modifier "NA"
set w2-dispersal-density-threshold "NA"



set t2-dispersal-modifier "NA"
set t2-dispersal-density-threshold "NA"


end

to new-t2-male
;set color lput 125 extract-rgb 29
;set shape "default" ; male

set sex "m"

set age 0
set disperser false
set density-immune false


set t-status 2
set w-dispersal-modifier "NA"
set w-dispersal-density-threshold "NA"


set w2-dispersal-modifier "NA"
set w2-dispersal-density-threshold "NA"


randomise-t-placement
end

to new-t2-female
;set color lput 125 extract-rgb 29
;set shape "pentagon" ; female

set sex "f"
set t-mating 0
set w-mating 0
set matings 0
set fecundity fecundity-global + random fecundity-random

set age 0
set disperser false
set t-fathers []

set w-fathers []
set t-fathers-disp []
set t2-fathers-disp []
set t-w-fathers-disp []
set w-fathers-disp []
set w2-fathers-disp []
set density-immune false














set t-fathers-disp-dd []
set t2-fathers-disp-dd []
set t-w-fathers-disp-dd []
set w-fathers-disp-dd []
set w2-fathers-disp-dd []


set t-status 2
set w-dispersal-modifier "NA"
set w-dispersal-density-threshold "NA"


set w2-dispersal-modifier "NA"
set w2-dispersal-density-threshold "NA"


randomise-t-placement
end


to new-w-male
;set color lput 125 extract-rgb 9
;set shape "default" ; male
set t-status 0
set sex "m"

set age 0
set disperser false
set density-immune false
randomise-w-placement

set t-dispersal-modifier "NA"
set t-dispersal-density-threshold "NA"



set t2-dispersal-modifier "NA"
set t2-dispersal-density-threshold "NA"


end

to new-w-female
;set color lput 125 extract-rgb 9
;set shape "pentagon" ; female
set t-status 0
set sex "f"
set t-mating 0
set w-mating 0
set matings 0
set fecundity fecundity-global + random fecundity-random

set age 0
set disperser false
set t-fathers []
set w-fathers []
set t-fathers-disp []
set t2-fathers-disp []
set t-w-fathers-disp []
set w-fathers-disp []
set w2-fathers-disp []
set density-immune false














set t-fathers-disp-dd []
set t2-fathers-disp-dd []
set t-w-fathers-disp-dd []
set w-fathers-disp-dd []
set w2-fathers-disp-dd []


randomise-w-placement

set t-dispersal-modifier "NA"
set t-dispersal-density-threshold "NA"



set t2-dispersal-modifier "NA"
set t2-dispersal-density-threshold "NA"


end


to-report find-sire [w-mates t-mates]
  let Ptsperm (1 / w-advantage) - 1 ; c/(c+1) = (1-wadvantage) in 1 : 1 mating

  if w-mates = 0 and t-mates >= 1
  [

   set Ptsperm 1

  ]

  let bottom (w-mates * 1) + (t-mates * (Ptsperm))

  let wm 0
  let tm 0
  loop
  [
    if w-mates > 0
    [
      set wm 0
      while [wm < w-mates]
      [
        if (1 / bottom) >= random-float 1.0
        [
          report (list (random w-mates) "w")
        ]
        set wm wm + 1
      ]
    ]
    if t-mates > 0
    [
      set tm 0
      while [tm < t-mates]
      [
        if (Ptsperm / bottom) >= random-float 1.0
        [
          report (list (random t-mates) "t")
        ]
        set tm tm + 1
      ]
    ]
  ]
end



to litter ; birth procedure
  ask patches [set last-turtle-count count turtles-on self]

ask turtles with [sex = "f" and matings > 0]

[





  let active-turtle who

  let fecundity-temp density-fecundity-change

  if (fecundity-temp > 0) [set total-litters total-litters + 1

  let sire 0

  ifelse t-status >= 1 ; t focal female

  [
    let pup 0 ; the iteration variable
    if (t-mating + w-mating) > 0 ; must have mated
      [

        set pup-count 0
        let t-prob t-mating


        while [ pup < fecundity-temp ]
        [

          ;ifelse t-prob >= random-float 1.0

          set sire find-sire w-mating t-mating
          ifelse item 1 sire = "t"
          [
            set random-father item 0 sire ; select a random t-carrying (+/t or t/t if possible) father
            ifelse (t-status = 2) ; t/t focal female?
            [



              ifelse (item random-father t-w-fathers-disp != "NA") ; this checks if the selected father has a wildtype variable a. If yes, then it is a +/t otherwise it is a t/t
              [
                f-t2-m-t1 who

              ]
              [

                f-t2-m-t2 who

              ]

            ]
            [


              ifelse (item random-father t-w-fathers-disp != "NA")
              [

                f-t1-m-t1 who

              ]
              [
                f-t1-m-t2 who
              ]

            ]



          ]
          [

            set random-father item 0 sire

            ifelse (t-status = 2)
            [
              f-t2-m-w who
            ]
            [

              f-t1-m-w who

            ]





          ]
          set pup pup + 1
        ]



        ;set label ""
      ]

  ]

  [
    let pup 0
    if (t-mating + w-mating) > 0
      [
        set pup-count 0
        let t-prob t-mating

        while [ pup < fecundity-temp ]
        [
            set sire find-sire w-mating t-mating
          ifelse item 1 sire = "t"
          [
            ; here we should select the t male and decide if it is a t1 or t2



            set random-father item 0 sire
            ifelse (item random-father t-w-fathers-disp != "NA")
            [

              f-w-m-t1 who


            ]
            [
              f-w-m-t2 who
            ]

            ; counts are managed in the functions











          ]
          [
            if (w-mating > 0)
            [
              set random-father item 0 sire

              f-w-m-w who




            ]
          ]
          set pup pup + 1
        ]


      ]
    ;set shape "pentagon"
    ;set size 1
    ;set label ""

  ]
      ]


  ; reset individual's variables

  set t-fathers []
  set w-fathers []

  set t-fathers-disp []
  set t2-fathers-disp []
  set t-w-fathers-disp []
  set w-fathers-disp []
  set w2-fathers-disp []

  set w-fathers-disp-dd []
  set w2-fathers-disp-dd []
  set t-fathers-disp-dd []
  set t2-fathers-disp-dd []
  set t-w-fathers-disp-dd []



  set t-mating 0
  set w-mating 0
  set matings 0













]




;set sr3 count turtles with [t-status = 1 and sex = "m"] / count turtles with [t-status = 1 and sex = "f"]
end


to death
ask turtles
  [




  ifelse random-float 1.0 < (death-prob) [

; old diagnostics

;        if t-status = 1 and sex = "m"
;        [
;           set tm-death-by-age tm-death-by-age + 1
;      ]
;        if t-status = 1 and sex = "f"
;        [
;           set tf-death-by-age tf-death-by-age + 1
;      ]
;
;             if t-status = 0 and sex = "m"
;        [
;           set wm-death-by-age wm-death-by-age + 1
;      ]
;        if t-status = 0 and sex = "f"
;        [
;           set wf-death-by-age wf-death-by-age + 1
;      ]


    die

    ]
  [

    ; density death moved to its own function


  ]

  ]
end

to patch-density-death


  if (density-death = true)
[
    ask patches
  [
      set pre-dispersal-count count turtles-here
      if (pre-dispersal-count > carrying-capacity)
  [

        ask n-of (pre-dispersal-count - carrying-capacity) turtles-here

        [

;      if t-status = 1 and sex = "m"
;        [
;           set tm-death-by-density tm-death-by-density + 1
;      ]
;        if t-status = 1 and sex = "f"
;        [
;           set tf-death-by-density tf-death-by-density + 1
;      ]
;
;          if t-status = 0 and sex = "m"
;        [
;           set wm-death-by-density wm-death-by-density + 1
;      ]
;        if t-status = 0 and sex = "f"
;        [
;           set wf-death-by-density wf-death-by-density + 1
;      ]

          die

        ]




        set pre-dispersal-count carrying-capacity

      ]

  ]
  ]


end

to-report density-fecundity-change

; in female turtle


    ifelse (density-fecundity = true)
    [
      let density-overflow [last-turtle-count] of [patch-here] of turtle who - (([carrying-capacity] of [patch-here] of turtle who) / 1)



      ; df$real_fecundity = ((df$fecundity-0) / (1+exp(0.2*(df$density-df$carrying_capacity))))

      let real_fecundity round ([fecundity] of turtle who / (1 + exp(0.1 * (24 + density-overflow))))

      if (random 1000 = 1)
      [
        ;print real_fecundity
      ]
      report real_fecundity
    ]

    [
      report [fecundity] of turtle who
    ]


end

to increment-age
  ask turtles
  [
  set age age + 1
]
end


to smart-report-current-genotypes ; new reporting system for Runge et al. it just reports the individual genotypes rather than expensively track all chromosomes

if (smart-report-geno = true)
[
  if (ticks mod geno-ids-print-interval = 0 or ticks < 3 or ticks >= (max-ticks - 10) or (ticks >= ((max-ticks / 2) - 10) and ticks <= ((max-ticks / 2) + 10)))
  [

    file-open word file-location file-name-geno-smart

    ifelse(ticks > 1)
    [
      ask turtles
      [

        file-print (word ticks "," w-dispersal-modifier "," w-dispersal-density-threshold "," w2-dispersal-modifier "," w2-dispersal-density-threshold "," t-dispersal-modifier "," t-dispersal-density-threshold "," t2-dispersal-modifier "," t2-dispersal-density-threshold)

      ]
    ]
    [
      file-print "tick, w-dispersal-modifier, w-dispersal-density-threshold, w2-dispersal-modifier, w2-dispersal-density-threshold, t-dispersal-modifier, t-dispersal-density-threshold, t2-dispersal-modifier, t2-dispersal-density-threshold"

    ]
    file-close-all
  ]
    print-counts-of-genotypes
]

end

to print-counts-of-genotypes

  if (smart-report-geno = true)
[

    if (ticks mod geno-ids-print-interval = 0 or ticks >= (max-ticks - 10))
  [

      file-open (word file-location file-name "-turtles-count.csv")

      ifelse(ticks > 1)
    [
        file-print (word ticks "," count-w "," count-t "," count-tt "," (count-w + count-t + count-tt))
      ]
      [
        file-print "tick,w,t,tt,all"
      ]
      file-close-all
    ]
  ]

  ;count-w
  ;count-t
  ;count-tt
  ;count-w + count-t + count-tt


end





to randomise-w-placement ; randomise between w and w2, so that there is no sex structure in inheritence on these "chromosomes"

if random 2 < 1
[
  let w-dispersal-modifier-temp w-dispersal-modifier
  set w-dispersal-modifier w2-dispersal-modifier
  set w2-dispersal-modifier w-dispersal-modifier-temp

  let w-dispersal-density-threshold-temp w-dispersal-density-threshold
  set w-dispersal-density-threshold w2-dispersal-density-threshold
  set w2-dispersal-density-threshold w-dispersal-density-threshold-temp


]


end

to randomise-t-placement ; randomise between t and t2, so that there is no sex structure in inheritence on these "chromosomes"

if random 2 < 1
[
  let t-dispersal-modifier-temp t-dispersal-modifier
  set t-dispersal-modifier t2-dispersal-modifier
  set t2-dispersal-modifier t-dispersal-modifier-temp

  let t-dispersal-density-threshold-temp t-dispersal-density-threshold
  set t-dispersal-density-threshold t2-dispersal-density-threshold
  set t2-dispersal-density-threshold t-dispersal-density-threshold-temp


]


end

to-report force-positive-values [value]

if (value < 0)
[
  set value value * -1
]

report value

end


to fix-forbidden-evolution [genotype] ; reset values outside the parameter space to the boundaries

if genotype = "t"
[
  if (w-dispersal-modifier > dispersal-mod-evolver) [set w-dispersal-modifier dispersal-mod-evolver]
  if (t-dispersal-modifier > dispersal-mod-evolver) [set t-dispersal-modifier dispersal-mod-evolver]
  ifelse (only_phenotypic_range = True)
    [
      if (w-dispersal-modifier < 0) [set w-dispersal-modifier 0]
      if (t-dispersal-modifier < 0) [set t-dispersal-modifier 0]
    ]
    [
      if (w-dispersal-modifier < (- dispersal-mod-evolver)) [set w-dispersal-modifier (- dispersal-mod-evolver)]
      if (t-dispersal-modifier < (- dispersal-mod-evolver)) [set t-dispersal-modifier (- dispersal-mod-evolver)]
    ]

if loci = 2
    [
      if (w-dispersal-density-threshold > (dispersal-dd-evolver)) [set w-dispersal-density-threshold dispersal-dd-evolver]
      if (t-dispersal-density-threshold > (dispersal-dd-evolver)) [set t-dispersal-density-threshold dispersal-dd-evolver]
      if (w-dispersal-density-threshold < (- dispersal-dd-evolver)) [set w-dispersal-density-threshold (- dispersal-dd-evolver)]
      if (t-dispersal-density-threshold < (- dispersal-dd-evolver)) [set t-dispersal-density-threshold (- dispersal-dd-evolver)]
    ]



]
if genotype = "t2"
[
  if (t-dispersal-modifier > dispersal-mod-evolver) [set t-dispersal-modifier dispersal-mod-evolver]
  if (t2-dispersal-modifier > dispersal-mod-evolver) [set t2-dispersal-modifier dispersal-mod-evolver]
  ifelse (only_phenotypic_range = True)
    [
      if (t-dispersal-modifier < 0) [set t-dispersal-modifier 0]
      if (t2-dispersal-modifier < 0) [set t2-dispersal-modifier 0]
    ]
    [
      if (t-dispersal-modifier < (- dispersal-mod-evolver)) [set t-dispersal-modifier (- dispersal-mod-evolver)]
      if (t2-dispersal-modifier < (- dispersal-mod-evolver)) [set t2-dispersal-modifier (- dispersal-mod-evolver)]
    ]
if loci = 2
    [
      if (t-dispersal-density-threshold > (dispersal-dd-evolver)) [set t-dispersal-density-threshold dispersal-dd-evolver]
      if (t2-dispersal-density-threshold > (dispersal-dd-evolver)) [set t2-dispersal-density-threshold dispersal-dd-evolver]
      if (t-dispersal-density-threshold < (- dispersal-dd-evolver)) [set t-dispersal-density-threshold (- dispersal-dd-evolver)]
      if (t2-dispersal-density-threshold < (- dispersal-dd-evolver)) [set t2-dispersal-density-threshold (- dispersal-dd-evolver)]
    ]



]
if genotype = "w2"
[
  if (w-dispersal-modifier > dispersal-mod-evolver) [set w-dispersal-modifier dispersal-mod-evolver]
  if (w2-dispersal-modifier > dispersal-mod-evolver) [set w2-dispersal-modifier dispersal-mod-evolver]
  ifelse (only_phenotypic_range = True)
    [
      if (w-dispersal-modifier < 0) [set w-dispersal-modifier 0]
      if (w2-dispersal-modifier < 0) [set w2-dispersal-modifier 0]
    ]
    [
      if (w-dispersal-modifier < (- dispersal-mod-evolver)) [set w-dispersal-modifier (- dispersal-mod-evolver)]
      if (w2-dispersal-modifier < (- dispersal-mod-evolver)) [set w2-dispersal-modifier (- dispersal-mod-evolver)]
    ]
if loci = 2
    [
      if (w-dispersal-density-threshold > (dispersal-dd-evolver)) [set w-dispersal-density-threshold dispersal-dd-evolver]
      if (w2-dispersal-density-threshold > (dispersal-dd-evolver)) [set w2-dispersal-density-threshold dispersal-dd-evolver]
      if (w-dispersal-density-threshold < (- dispersal-dd-evolver)) [set w-dispersal-density-threshold (- dispersal-dd-evolver)]
      if (w2-dispersal-density-threshold < (- dispersal-dd-evolver)) [set w2-dispersal-density-threshold (- dispersal-dd-evolver)]
    ]



]

end

to-report negative-or-positive
let initial random 2
if (initial = 0)
[report -1]
if (initial = 1)
[report 1]
end

; now follow all the possible mating combinations and their specific consequences

to f-w-m-w [active-turtle]

; can go to hatching immediately, because there is no confusion about which genotype is transmitted

hatch 1 ; this creates a new mouse, an offspring
[



      if (random-father = length w-fathers-disp-dd) [print (word random-father w-fathers-disp-dd w-fathers)]

      set inherited-from item random-father w-fathers

      ;                   ifelse (count turtles with [who = inherited-from] > 0)
      ;                   [
      ;
      ;                   ifelse random 2 < 1 ;which w
      ;                   [
      ;                     set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
      ;                   ]
      ;                   [
      ;                     set w-dispersal-modifier [w2-dispersal-modifier] of turtle inherited-from
      ;                   ]
      ;
      ;                   ]
      ;[
      let f-chromosome random 2 ; randomising which of the two wildtype chromosomes is transmitted from mother to offspring
      let m-chromosome random 2

      ifelse m-chromosome < 1 ;which w
        [
          set w-dispersal-modifier item random-father w-fathers-disp
        ]
        [
          set w-dispersal-modifier item random-father w2-fathers-disp
        ]
      ;]
      set inherited-from active-turtle


      ifelse f-chromosome < 1 ;which w
        [
          set w2-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
        ]
        [
          set w2-dispersal-modifier [w2-dispersal-modifier] of turtle inherited-from
        ]



      if (loci = 2) [


        ifelse m-chromosome < 1 ;which w
        [
          set w-dispersal-density-threshold item random-father w-fathers-disp-dd
        ]
        [
          set w-dispersal-density-threshold item random-father w2-fathers-disp-dd
        ]

        ifelse f-chromosome < 1 ;which w
          [
            set w2-dispersal-density-threshold [w-dispersal-density-threshold] of turtle active-turtle
          ]
          [
            set w2-dispersal-density-threshold [w2-dispersal-density-threshold] of turtle active-turtle
          ]







        ]



      check-for-mutations ; mutation function
      fix-forbidden-evolution "w2" ; limit values to the parameter spaces


  ifelse random 2 < 1
    [
      new-w-male
    ]
    [
      new-w-female
    ]





]

end

to f-w-m-t1 [active-turtle]

hatch 1 [

  ifelse (random-float 1 <= drive) ;male t-drive
    [

      ifelse (evolve-dispersal = true)
        [
          if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

          set inherited-from item random-father t-fathers

          ;                   ifelse (count turtles with [who = inherited-from] > 0)
          ;                   [
          ;                   set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
          ;
          ;                   if (t-dispersal-modifier = 0) [print "0 inherited from father!"]
          ;                   ]
          ;                   [
          set t-dispersal-modifier item random-father t-fathers-disp
          ;if (t-dispersal-modifier = 0) [print t-fathers-disp]
          ;]
          let f-chromosome random 2
          set inherited-from active-turtle


          ifelse f-chromosome < 1 ;which w
            [
              set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
            ]
            [
              set w-dispersal-modifier [w2-dispersal-modifier] of turtle inherited-from
            ]



          if (loci = 2) [

            set t-dispersal-density-threshold item random-father t-fathers-disp-dd
            ifelse f-chromosome < 1 ;which w
              [
                set w-dispersal-density-threshold [w-dispersal-density-threshold] of turtle inherited-from
              ]
              [
                set w-dispersal-density-threshold [w2-dispersal-density-threshold] of turtle inherited-from
              ]







          ]
          check-for-mutations
          fix-forbidden-evolution "t"
        ]
        [set w-dispersal-modifier 1 set t-dispersal-modifier 1]
      ifelse random 2 < 1
        [
          new-t-male

        ]
        [
          new-t-female

        ]



    ]
    [

      ifelse (evolve-dispersal = true)
        [
          if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]



          set inherited-from item random-father t-fathers


          ;                   ifelse (count turtles with [who = inherited-from] > 0)
          ;                   [
          ;                   set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
          ;
          ;                   ]
          ;                   [
          set w-dispersal-modifier item random-father t-w-fathers-disp
          ;]
          set inherited-from active-turtle


          ifelse random 2 < 1 ;which w
            [
              set w2-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
            ]
            [
              set w2-dispersal-modifier [w2-dispersal-modifier] of turtle inherited-from
            ]



          if (loci = 2) [

            set w-dispersal-density-threshold  item random-father t-w-fathers-disp-dd
            ifelse random 2 < 1 ;which w
              [
                set w2-dispersal-density-threshold [w-dispersal-density-threshold] of turtle inherited-from
              ]
              [
                set w2-dispersal-density-threshold [w2-dispersal-density-threshold] of turtle inherited-from
              ]









          ]
          check-for-mutations
          fix-forbidden-evolution "w2"
        ]
        [set w-dispersal-modifier 1
          set w2-dispersal-modifier 1]
      ifelse random 2 < 1
        [
          new-w-male
        ]
        [
          new-w-female
        ]



    ]


]
end


to f-w-m-t2 [active-turtle]

hatch 1 [

  ifelse (evolve-dispersal = true)
    [
      if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]
      set inherited-from item random-father t-fathers

      ;                   ifelse (count turtles with [who = inherited-from] > 0)
      ;                   [
      ;			ifelse random 2 < 1; which t
      ;[
      ;	                   set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
      ;]
      ;[
      ;		                   set t-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
      ;]
      ;
      ;
      ;                   if (t-dispersal-modifier = 0) [print "0 inherited from father!"]
      ;                   ]
      ;                   [
      let m-chromosome random 2
      let f-chromosome random 2
      ifelse m-chromosome < 1
        [
          set t-dispersal-modifier item random-father t-fathers-disp
        ]
        [
          set t-dispersal-modifier item random-father t2-fathers-disp
        ]

      ;if (t-dispersal-modifier = 0) [print t-fathers-disp]
      ;]

      set inherited-from active-turtle


      ifelse f-chromosome < 1 ;which w
        [
          set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
        ]
        [
          set w-dispersal-modifier [w2-dispersal-modifier] of turtle inherited-from
        ]



      if (loci = 2) [


        ifelse m-chromosome < 1; which t
        [
          	                   set t-dispersal-density-threshold item random-father t-fathers-disp-dd
        ]
        [
          		                   set t-dispersal-density-threshold item random-father t2-fathers-disp-dd
        ]


        ;set t-dispersal-density-threshold item random-father t-fathers-disp-dd


        ifelse f-chromosome < 1 ;which w
          [
            set w-dispersal-density-threshold [w-dispersal-density-threshold] of turtle inherited-from
          ]
          [
            set w-dispersal-density-threshold [w2-dispersal-density-threshold] of turtle inherited-from
          ]









      ]
      check-for-mutations
      fix-forbidden-evolution "t"
    ]
    [set w-dispersal-modifier 1 set t-dispersal-modifier 1]
  ifelse random 2 < 1
    [
      new-t-male
    ]
    [
      new-t-female
    ]



]
end

to f-t1-m-w [active-turtle]

hatch 1
  [

    if (w-mating > 0)
      [
        ifelse random 2 < 1 ;chance of t egg
          [

            ifelse (evolve-dispersal = true)
              [

                if (random-father = length w-fathers-disp-dd) [print (word random-father w-fathers-disp-dd w-fathers)]
                set inherited-from item random-father w-fathers

                ;                   ifelse (count turtles with [who = inherited-from] > 0)
                ;                   [
                ;                   set w-dispersal-modifier median [w-dispersal-modifier] of turtles with [who = inherited-from]
                ;
                ;                   ]
                ;                   [
                let m-chromosome random 2
                ifelse m-chromosome < 1
                  [
                    set w-dispersal-modifier item random-father w-fathers-disp
                  ]
                  [
                    set w-dispersal-modifier item random-father w2-fathers-disp
                  ]
                ;set inherited-from active-turtle
                ;                   if (count turtles with [who = inherited-from] > 0)
                ;                   [
                ;                   let dispersal-modifier-temp median [dispersal-modifier] of turtles with [who = inherited-from]
                ;                   set dispersal-modifier dispersal-modifier-temp + dispersal-modifier
                ;                   set dispersal-modifier (dispersal-modifier / 2)
                ;                   ]





                set inherited-from active-turtle

                set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
                ;if (t-dispersal-modifier = 0) [print "0 inherited from mum!"]




                if (loci = 2) [
                  ifelse m-chromosome < 1
                  [
                    set w-dispersal-density-threshold item random-father w-fathers-disp-dd
                  ]
                  [
                    set w-dispersal-density-threshold item random-father w2-fathers-disp-dd
                  ]



                  set t-dispersal-density-threshold  [t-dispersal-density-threshold] of turtle active-turtle






                ]
                check-for-mutations
                fix-forbidden-evolution "t"
              ]
              [set w-dispersal-modifier 1 set t-dispersal-modifier 1]

            ifelse random 2 < 1 ;+sperm meets t egg
              [
                new-t-male
              ]
              [
                new-t-female
              ]





          ]
          [ ;w sperm, w egg

            ifelse (evolve-dispersal = true)
              [

                if (random-father = length w-fathers-disp-dd) [print (word random-father w-fathers-disp-dd w-fathers)]
                set inherited-from item random-father w-fathers

                ;                   ifelse (count turtles with [who = inherited-from] > 0)
                ;                   [
                ;
                ;                   ifelse random 2 < 1 ; which w to inherit
                ;                   [
                ;                     set w-dispersal-modifier median [w-dispersal-modifier] of turtles with [who = inherited-from]
                ;                   ]
                ;                   [
                ;                     set w-dispersal-modifier median [w2-dispersal-modifier] of turtles with [who = inherited-from]
                ;                   ]
                ;
                ;                   ]
                ;                   [

                let m-chromosome random 2

                ifelse m-chromosome < 1 ; which w to inherit
                  [
                    set w-dispersal-modifier item random-father w-fathers-disp
                  ]
                  [
                    set w-dispersal-modifier item random-father w2-fathers-disp
                  ]

                set inherited-from active-turtle

                set w2-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from



                if (loci = 2) [


                  ifelse m-chromosome < 1 ; which w to inherit
                    [
                      set w-dispersal-density-threshold item random-father w-fathers-disp-dd
                    ]
                    [
                      set w-dispersal-density-threshold item random-father w2-fathers-disp-dd
                    ]
                  set w2-dispersal-density-threshold  [w-dispersal-density-threshold] of turtle active-turtle










                ]
                check-for-mutations
                fix-forbidden-evolution "w2"
              ]
              [set w-dispersal-modifier 1 set w2-dispersal-modifier 1]
            ifelse random 2 < 1 ;+ sperm meets + egg
              [
                new-w-male
              ]
              [
                new-w-female
              ]



          ]
      ]


  ]


end



to f-t1-m-t1 [active-turtle]

; no hatch here because otherwise t never lethal

ifelse (random-float 1 <= drive) ;male drive
  [
    ifelse ((random 2 < 1))
      [




        if (random-float 1 < t-homozygous-viability)
          [
            hatch 1

            [
              ifelse (evolve-dispersal = true)
                [
                  if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

                  set inherited-from item random-father t-fathers

                  ;print count turtles with [who = inherited-from]
                  ;                   ifelse (count turtles with [who = inherited-from] > 0)
                  ;                   [
                  ;                   set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
                  ;
                  ;                   ;print word inherited-from "."
                  ;                   ]
                  ;                   [
                  set t-dispersal-modifier item random-father t-fathers-disp

                  ;]

                  set inherited-from active-turtle

                  set t2-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from




                  if (loci = 2) [
                    set t-dispersal-density-threshold item random-father t-fathers-disp-dd
                    set t2-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from





                  ]
                  check-for-mutations
                  fix-forbidden-evolution "t2"
                ]
                [set t2-dispersal-modifier 1
                  set t-dispersal-modifier 1]

              ifelse random 2 < 1
                [ new-t2-male ][new-t2-female] ;t sperm meets t egg
            ]
          ]



      ]


    [
      hatch 1

      [
        ifelse (evolve-dispersal = true)
          [
            ifelse (random 2 = 1) ;take t from father
              [

                if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

                set inherited-from item random-father t-fathers

                ;print count turtles with [who = inherited-from]
                ;                   ifelse (count turtles with [who = inherited-from] > 0)
                ;                   [
                ;                   set t-dispersal-modifier median [t-dispersal-modifier] of turtles with [who = inherited-from]
                ;
                ;                   ;print word inherited-from "."
                ;                   ]
                ;                   [
                set t-dispersal-modifier item random-father t-fathers-disp
                ;]

                set inherited-from active-turtle

                set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from




                if (loci = 2) [
                  set t-dispersal-density-threshold item random-father t-fathers-disp-dd
                  set w-dispersal-density-threshold [w-dispersal-density-threshold] of turtle inherited-from


    	



                ]

              ]
              [

                if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

                set inherited-from item random-father t-fathers

                ;print count turtles with [who = inherited-from]
                ;                   ifelse (count turtles with [who = inherited-from] > 0)
                ;                   [
                ;                   set t-dispersal-modifier median [t-dispersal-modifier] of turtles with [who = inherited-from]
                ;
                ;                   ;print word inherited-from "."
                ;                   ]
                ;                   [
                set w-dispersal-modifier item random-father t-w-fathers-disp
                ;]

                set inherited-from active-turtle

                set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from




                if (loci = 2) [
                  set w-dispersal-density-threshold item random-father t-w-fathers-disp-dd
                  set t-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from





                ]

              ]
            check-for-mutations
            fix-forbidden-evolution "t"
          ]
          [set w-dispersal-modifier 1
            set t-dispersal-modifier 1]

        ifelse random 2 < 1
          [new-t-male]
          [new-t-female] ;t sperm meets w egg



      ]



    ]
  ]
  [

    ;w sperm from t male
    hatch 1

    [

      ifelse (evolve-dispersal = true)
        [
          ; take the dd0 from w-dd0 of a t father
          if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]
          set inherited-from item random-father t-fathers


          set w-dispersal-modifier item random-father t-w-fathers-disp
          set w-dispersal-density-threshold item random-father t-w-fathers-disp-dd




        ]
        [set w-dispersal-modifier 1]

      ifelse random 2 < 1 ; t or w egg?
        [
          ifelse (evolve-dispersal = true)
            [
              set inherited-from active-turtle

              set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from



              if (loci = 2) [
                set t-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from



              ]

            ]
            [
              set t-dispersal-modifier 1  set w-dispersal-modifier 1
            ]
          ifelse random 2 < 1 ;+ sperm meets t egg
            [
              new-t-male
            ]
            [
              new-t-female
            ]


          check-for-mutations
          fix-forbidden-evolution "t"

        ]
        [
          ifelse (evolve-dispersal = true)
            [
              set inherited-from active-turtle

              set w2-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from ;w2 from w because t/w female




              if (loci = 2) [

                set w2-dispersal-density-threshold  [w-dispersal-density-threshold] of turtle active-turtle







              ]

            ]
            [set w-dispersal-modifier 1
              set w2-dispersal-modifier 1]
          ifelse random 2 < 1 ;+ meets +
            [
              new-w-male
            ]
            [
              new-w-female
            ]
          check-for-mutations
          fix-forbidden-evolution "w2"


        ]



    ]
  ]





end


to f-t1-m-t2 [active-turtle]

; no male drive





    ifelse (random 2 < 1)

    [

        if (random-float 1 < t-homozygous-viability)
        [
        hatch 1

  [
      ; t egg


      ifelse (evolve-dispersal = true)
        [
          if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

          set inherited-from item random-father t-fathers

          ;print count turtles with [who = inherited-from]
          ;                   ifelse (count turtles with [who = inherited-from] > 0)
          ;                   [
          ;ifelse random 2 < 1 ; which t
          ;[
          ;                   set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
          ;]
          ;[
          ;                   set t-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
          ;]
          ;
          ;
          ;                   ;print word inherited-from "."
          ;                   ]
          ;                   [
          let m-chromosome random 2
          ifelse m-chromosome < 1
            [
              set t-dispersal-modifier item random-father t-fathers-disp

            ]
            [
              set t-dispersal-modifier item random-father t2-fathers-disp

            ]

          set inherited-from active-turtle

          set t2-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from



          let inherited-from-sire item random-father t-fathers
          if (loci = 2) [

            ifelse m-chromosome < 1
              [
                set t-dispersal-density-threshold item random-father t-fathers-disp-dd
              ]
              [
                set t-dispersal-density-threshold item random-father t2-fathers-disp-dd
              ]

            set t2-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from





          ]
          check-for-mutations
          fix-forbidden-evolution "t2"
        ]
        [set t2-dispersal-modifier 1
          set t-dispersal-modifier 1]



      ifelse random 2 < 1
        [ new-t2-male ][new-t2-female]



    ]
      ]
  ]
    [
    hatch 1

  [
      ; w egg


      ifelse (evolve-dispersal = true)
        [
          if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

          set inherited-from item random-father t-fathers

          ;print count turtles with [who = inherited-from]
          ;                   ifelse (count turtles with [who = inherited-from] > 0)
          ;                   [
          ;ifelse random 2 < 1 ; which t
          ;[
          ;                   set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
          ;]
          ;[
          ;                   set t-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
          ;]
          ;
          ;
          ;                   ;print word inherited-from "."
          ;                   ]
          ;                   [
          let m-chromosome random 2
          ifelse m-chromosome < 1
            [
              set t-dispersal-modifier item random-father t-fathers-disp
            ]
            [
              set t-dispersal-modifier item random-father t2-fathers-disp
            ]

          set inherited-from active-turtle

          set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from




          let inherited-from-sire item random-father t-fathers
          if (loci = 2) [

            ifelse m-chromosome < 1
              [
                set t-dispersal-density-threshold item random-father t-fathers-disp-dd
              ]
              [
                set t-dispersal-density-threshold item random-father t2-fathers-disp-dd
              ]

            set w-dispersal-density-threshold [w-dispersal-density-threshold] of turtle inherited-from





          ]
          check-for-mutations
          fix-forbidden-evolution "t"
        ]
        [set w-dispersal-modifier 1
          set t-dispersal-modifier 1]

      ifelse random 2 < 1
        [ new-t-male ][new-t-female] ;t sperm meets w egg





    ]

  ]




end


to f-t2-m-w [active-turtle]

hatch 1

[

  ifelse (evolve-dispersal = true)
    [
      if (random-father = length w-fathers-disp-dd) [print (word random-father w-fathers-disp-dd w-fathers)]

      set inherited-from item random-father w-fathers

      ;                   ifelse (count turtles with [who = inherited-from] > 0)
      ;                   [
      ;			ifelse random 2 < 1; which w
      ;[
      ;	                   set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
      ;]
      ;[
      ;		                   set w-dispersal-modifier [w2-dispersal-modifier] of turtle inherited-from
      ;]
      ;
      ;
      ;                   if (w-dispersal-modifier = 0) [print "0 inherited from father!"]
      ;                   ]
      let m-chromosome random 2
      let f-chromosome random 2
      ifelse m-chromosome < 1
        [
          set w-dispersal-modifier item random-father w-fathers-disp

        ]
        [
          set w-dispersal-modifier item random-father w2-fathers-disp
        ]

      set inherited-from active-turtle


      ifelse f-chromosome < 1 ;which w
        [
          set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
        ]
        [
          set t-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
        ]



      if (loci = 2) [

        ;let inherited-from-sire item random-father w-fathers

        ifelse m-chromosome < 1; which w
        [
          	                   set w-dispersal-density-threshold item random-father w-fathers-disp-dd
        ]
        [
          		                   set w-dispersal-density-threshold item random-father w2-fathers-disp-dd
        ]


        ;set w-dispersal-density-threshold item random-father w-fathers-disp-dd


        ifelse f-chromosome < 1 ;which t
          [
            set t-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from
          ]
          [
            set t-dispersal-density-threshold [t2-dispersal-density-threshold] of turtle inherited-from
          ]








      ]
      check-for-mutations
      fix-forbidden-evolution "t"
    ]
    [set w-dispersal-modifier 1 set t-dispersal-modifier 1]
  ifelse random 2 < 1
    [
      new-t-male
    ]
    [
      new-t-female
    ]


]


end

to f-t2-m-t2 [active-turtle]

if (random-float 1 < t-homozygous-viability)
  [



  hatch 1

[

  ifelse (evolve-dispersal = true)
    [

      if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

      set inherited-from item random-father t-fathers

      ;                   ifelse (count turtles with [who = inherited-from] > 0)
      ;                   [
      ;
      ;                   ifelse random 2 < 1 ;which t
      ;                   [
      ;                     set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
      ;                   ]
      ;                   [
      ;                     set t-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
      ;                   ]
      ;
      ;                   ]
      let m-chromosome random 2
      let f-chromosome random 2
      ifelse m-chromosome < 1
        [

          set t-dispersal-modifier item random-father t-fathers-disp
          if item random-father t-fathers-disp = "NA" [print "NA1!!"]


        ]
        [
          set t-dispersal-modifier item random-father t2-fathers-disp
          if item random-father t2-fathers-disp = "NA" [print (word "NA2!! " [t-status] of turtle inherited-from " " item random-father t-fathers-disp " " item random-father t-w-fathers-disp " " item random-father t2-fathers-disp)]
        ]
      set inherited-from active-turtle


      ifelse f-chromosome < 1 ;which t
        [
          set t2-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
        ]
        [
          set t2-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
        ]


      if (loci = 2) [



        ifelse m-chromosome < 1 ;which t
        [
          set t-dispersal-density-threshold item random-father t-fathers-disp-dd
        ]
        [
          set t-dispersal-density-threshold item random-father t2-fathers-disp-dd
        ]

        ifelse f-chromosome < 1 ;which t
          [
            set t2-dispersal-density-threshold [t-dispersal-density-threshold] of turtle active-turtle
          ]
          [
            set t2-dispersal-density-threshold [t2-dispersal-density-threshold] of turtle active-turtle
          ]









      ]
      check-for-mutations
      fix-forbidden-evolution "t2"
    ]
    [set t-dispersal-modifier 1
      set t2-dispersal-modifier 1]
  ifelse random 2 < 1
    [
      new-t2-male
    ]
    [
      new-t2-female
    ]



    ]
]

end



to f-t2-m-t1 [active-turtle]

let f-chromosome random 2




  ifelse (random-float 1 <= drive) ;male drive
    [
      if (random-float 1 < t-homozygous-viability)
      [
        hatch 1

[
      ; t sperm

      ifelse (evolve-dispersal = true)
        [
          if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

          set inherited-from item random-father t-fathers

          ;print count turtles with [who = inherited-from]
          ;                   ifelse (count turtles with [who = inherited-from] > 0)
          ;                   [
          ;                   set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
          ;
          ;                   ;print word inherited-from "."
          ;                   ]


          set t-dispersal-modifier item random-father t-fathers-disp


          set inherited-from active-turtle

          ifelse f-chromosome < 1 ; which t
          [
            set t2-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
          ]
          [
            set t2-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
          ]




          if (loci = 2) [
            set t-dispersal-density-threshold item random-father t-fathers-disp-dd

            ifelse f-chromosome < 1 ; which t
            [
              set t2-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from
            ]
            [
              set t2-dispersal-density-threshold [t2-dispersal-density-threshold] of turtle inherited-from
            ]






          ]
          check-for-mutations
          fix-forbidden-evolution "t2"
        ]
        [set t2-dispersal-modifier 1
          set t-dispersal-modifier 1]

      ifelse random 2 < 1
        [ new-t2-male ][new-t2-female] ;t sperm meets t egg





        ]
    ]
    ]


  [
    ; w sperm
hatch 1

[

    ifelse (evolve-dispersal = true)
      [
        if (random-father = length t-fathers-disp-dd) [print (word random-father t-fathers-disp-dd t-fathers)]

        set inherited-from item random-father t-fathers

        ;print count turtles with [who = inherited-from]
        ;                   ifelse (count turtles with [who = inherited-from] > 0)
        ;                   [
        ;                   set w-dispersal-modifier [w-dispersal-modifier] of turtle inherited-from
        ;
        ;                   ;print word inherited-from "."
        ;                   ]
        ;                   [
        set w-dispersal-modifier item random-father t-w-fathers-disp
        ;]

        set inherited-from active-turtle

        ifelse f-chromosome < 1 ; which t
        [
          set t-dispersal-modifier [t-dispersal-modifier] of turtle inherited-from
        ]
        [
          set t-dispersal-modifier [t2-dispersal-modifier] of turtle inherited-from
        ]



        if (loci = 2) [
          set w-dispersal-density-threshold item random-father t-w-fathers-disp-dd

          ifelse f-chromosome < 1 ; which t
          [
            set t-dispersal-density-threshold [t-dispersal-density-threshold] of turtle inherited-from
          ]
          [
            set t-dispersal-density-threshold [t2-dispersal-density-threshold] of turtle inherited-from
          ]






        ]
        check-for-mutations
        fix-forbidden-evolution "t"
      ]
      [set w-dispersal-modifier 1
        set t-dispersal-modifier 1]

    ifelse random 2 < 1
      [ new-t-male ][new-t-female] ;w sperm meets t egg







  ]


]



end




to report-patches [first-time]
file-open (word file-location file-name "-patches") ;file-name is classicly for report-litters, others will be extended by their purpose, e.g. -geno
if first-time = TRUE
  [
    file-print "ticks,ID,cc,dispersal-count,last-count,turtles-p,t-turtles-p,w-turtles-p,t1-turtles-p"
  ]
ask patches
  [
    file-print (word ticks "," self "," carrying-capacity "," pre-dispersal-count "," last-turtle-count "," count turtles-here "," count turtles-here with [t-status >= 1] "," count turtles-here with [t-status = 0] "," count turtles-here with [t-status = 1])
  ]
file-close-all
end

to report-matings [first-time]
file-open (word file-location file-name "-matings") ;file-name is classicly for report-litters, others will be extended by their purpose, e.g. -geno
if first-time = TRUE
  [
    file-print (word "ticks" "," "ID" "," "density" "," "density-males" "," "age" "," "matings" "," "t-status" "," "t-matings" "," "w-matings")
  ]
ask turtles with [sex = "f"]
  [
    file-print (word ticks "," self "," count turtles-here "," count turtles-here with [sex = "m"] "," age "," matings "," t-status "," t-mating "," w-mating)
  ]
file-close-all
end

to-report mutate [oldvalue parameterspace dividedby applyonlypheno]
let newvalue oldvalue
if random-float 1 <= P_inc
[
    ;print oldvalue

      set newvalue oldvalue + ((parameterspace * (1 / dividedby)) * negative-or-positive)

    if(only_phenotypic_range = true)
    [
      ;set newvalue oldvalue + (random-float (parameterspace * (1 / dividedby)) * negative-or-positive)
;      if(newvalue < 0)
;      [
;        set newvalue 0
;      ]
    ]
    ;print newvalue
]
if random-float 1 <= P_full
[

  set newvalue ((random-float parameterspace) * negative-or-positive)

    if(only_phenotypic_range = true and applyonlypheno = true)
    [
      set newvalue random-float parameterspace
;      if(newvalue < 0)
;      [
;        set newvalue 0
;      ]
    ]

]
report newvalue


end

to check-for-mutations
; this is executed within a hatch after all variables have been establish for this new individual
; this is supposed to reduce the code redundancy
if t-status = 0
[

  set w-dispersal-modifier mutate w-dispersal-modifier dispersal-mod-evolver d0-dividedby true
  set w2-dispersal-modifier mutate w2-dispersal-modifier dispersal-mod-evolver d0-dividedby true

if loci = 2 [
      set w-dispersal-density-threshold mutate w-dispersal-density-threshold dispersal-dd-evolver d1-dividedby false
      set w2-dispersal-density-threshold mutate w2-dispersal-density-threshold dispersal-dd-evolver d1-dividedby false
    ]




]
if t-status = 1
[
  set t-dispersal-modifier mutate t-dispersal-modifier dispersal-mod-evolver d0-dividedby true
  set w-dispersal-modifier mutate w-dispersal-modifier dispersal-mod-evolver d0-dividedby true

if loci = 2 [
      set t-dispersal-density-threshold mutate t-dispersal-density-threshold dispersal-dd-evolver d1-dividedby false
      set w-dispersal-density-threshold mutate w-dispersal-density-threshold dispersal-dd-evolver d1-dividedby false
    ]


]
if t-status = 2
[

  set t-dispersal-modifier mutate t-dispersal-modifier dispersal-mod-evolver d0-dividedby true
  set t2-dispersal-modifier mutate t2-dispersal-modifier dispersal-mod-evolver d0-dividedby true

    if loci = 2 [
       set t-dispersal-density-threshold mutate t-dispersal-density-threshold dispersal-dd-evolver d1-dividedby false
      set t2-dispersal-density-threshold mutate t2-dispersal-density-threshold dispersal-dd-evolver d1-dividedby false
    ]


]
end
@#$#@#$#@
GRAPHICS-WINDOW
590
50
919
321
-1
-1
29.2
1
10
1
1
1
0
0
0
1
-5
5
-4
4
1
1
1
ticks
30.0

BUTTON
8
10
71
43
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
74
10
167
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
926
104
1118
137
starting-number
starting-number
4
10000
5000.0
4
1
NIL
HORIZONTAL

MONITOR
92
50
142
95
+/t
count turtles with [t-status = 1]
3
1
11

MONITOR
13
50
87
95
+/+ count
count turtles with [t-status = 0]
3
1
11

PLOT
10
100
580
340
Genotype population sizes
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-1" 1.0 0 -7500403 true "" "plot count turtles with [t-status = 0]"
"pen-2" 1.0 0 -955883 true "" "plot count turtles with [t-status = 1]\n"
"pen-3" 1.0 0 -10649926 true "" "plot count turtles with [density-immune = true]"
"pen-4" 1.0 0 -6459832 true "" "plot count patches with [density-immune-patch = true]"
"tt" 1.0 0 -2674135 true "" "plot count turtles with [t-status = 2]"

SLIDER
1895
262
2067
295
t-starting-frequency
t-starting-frequency
1
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
947
299
1119
332
dispersal-cost
dispersal-cost
-0.01
1
0.3
0.01
1
NIL
HORIZONTAL

SWITCH
2593
373
2712
406
end-with-t?
end-with-t?
0
1
-1000

SLIDER
20
734
216
767
drive
drive
0.5
0.99
0.9
0.001
1
NIL
HORIZONTAL

MONITOR
502
50
581
95
sex ratio
count turtles with [sex = \"m\"] / count turtles with [sex = \"f\"]
2
1
11

MONITOR
348
52
505
97
t chr fraction
((count-t / 2) + count-tt) / (count-t + count-tt + count-w)
2
1
11

SLIDER
950
255
1135
288
death-prob
death-prob
0
1
0.25
0.01
1
NIL
HORIZONTAL

MONITOR
216
50
335
95
mean matings
mean-matings
2
1
11

SWITCH
2592
290
2764
323
evolve-dispersal
evolve-dispersal
0
1
-1000

SLIDER
1884
178
2102
211
dispersal-mod-evolver
dispersal-mod-evolver
0
10
1.0
0.01
1
NIL
HORIZONTAL

SWITCH
680
566
895
599
only-juvenile-dispersal
only-juvenile-dispersal
0
1
-1000

SLIDER
239
667
411
700
w-advantage
w-advantage
0
1
0.85
0.01
1
NIL
HORIZONTAL

SLIDER
1882
99
2134
132
dispersal-mod-evolver-start
dispersal-mod-evolver-start
0
5
0.5
0.01
1
NIL
HORIZONTAL

SWITCH
686
332
835
365
patch-fidelity
patch-fidelity
0
1
-1000

SLIDER
1862
397
2034
430
fecundity-global
fecundity-global
1
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
1862
359
2044
392
fecundity-random
fecundity-random
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
1872
16
2073
49
dispersal-dd-evolver
dispersal-dd-evolver
0
10
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
1883
59
2123
92
dispersal-dd-evolver-start
dispersal-dd-evolver-start
-5
5
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
938
59
1110
92
max-ticks
max-ticks
0
1000000
100000.0
1
1
NIL
HORIZONTAL

SLIDER
1316
58
1452
91
geno-ids-print-interval
geno-ids-print-interval
1
10000
1000.0
1
1
NIL
HORIZONTAL

PLOT
0
478
296
598
Slope
NIL
NIL
0.0
1.0
0.0
0.0
true
false
"" ""
PENS
"default" 1.0 0 -955883 true "" "plot ((median [t-dispersal-density-threshold] of turtles with [t-status = 1]))"
"pen-1" 1.0 0 -7500403 true "" "plot ((median [w-dispersal-density-threshold] of turtles with [t-status = 0] + mean [w2-dispersal-density-threshold] of turtles with [t-status = 0]) / 2)"
"pen-2" 1.0 0 -2674135 true "" "plot ((median [t-dispersal-density-threshold] of turtles with [t-status = 2] + mean [t2-dispersal-density-threshold] of turtles with [t-status = 2]) / 2)"
"pen-4" 1.0 0 -16777216 true "" "plot 0"

PLOT
2
352
305
483
Intercept
NIL
NIL
0.0
1.0
0.5
0.5
true
false
"" ""
PENS
"default" 1.0 0 -9276814 true "" "plot ((median [w-dispersal-modifier] of turtles with [t-status = 0] + mean [w2-dispersal-modifier] of turtles with [t-status = 0]) / 2)"
"pen-1" 1.0 0 -955883 true "" "plot (median [t-dispersal-modifier] of turtles with [t-status = 1])"
"pen-2" 1.0 0 -2674135 true "" "plot ((median [t-dispersal-modifier] of turtles with [t-status = 2] + mean [t2-dispersal-modifier] of turtles with [t-status = 2]) / 2)"

MONITOR
152
50
209
95
t / t
count turtles with [t-status = 2]
17
1
11

SWITCH
2594
329
2905
362
extended-disadvantage-adaptation
extended-disadvantage-adaptation
1
1
-1000

SWITCH
1289
102
1478
135
smart-report-geno
smart-report-geno
1
1
-1000

SWITCH
1292
146
1457
179
patches-report
patches-report
1
1
-1000

SWITCH
1295
188
1459
221
matings-report
matings-report
1
1
-1000

SWITCH
1709
597
1865
630
density-death
density-death
0
1
-1000

SWITCH
682
450
851
483
shuffle-patches
shuffle-patches
1
1
-1000

SLIDER
682
527
899
560
shuffle-patches-timing
shuffle-patches-timing
0
100
1.0
1
1
NIL
HORIZONTAL

SWITCH
1710
634
1889
667
density-fecundity
density-fecundity
0
1
-1000

INPUTBOX
1318
236
1462
296
file-location
F:/
1
0
String

CHOOSER
23
779
161
824
t-effect
t-effect
"additive" "dominant"
1

TEXTBOX
2138
205
2563
508
Right of here are alternative and outdated/unsupported options.\n\nIf default setting is on, then off is currently unintended and vice versa. Same goes for changing values.
30
15.0
1

INPUTBOX
1705
535
1764
595
cc-mean
50.0
1
0
Number

SWITCH
2594
250
2835
283
new-density-dependent-dispersal
new-density-dependent-dispersal
0
1
-1000

INPUTBOX
1696
458
1851
518
P_inc_set
1.0
1
0
Number

PLOT
316
353
656
480
Histogram Intercept
NIL
NIL
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.1 1 -955883 true "" "histogram [t-dispersal-modifier] of turtles with [t-status = 1 or t-status = 2]"
"pen-1" 0.1 1 -7500403 true "" "histogram [w-dispersal-modifier] of turtles with [t-status = 0]"

SLIDER
237
707
454
740
t-homozygous-viability
t-homozygous-viability
0
1.0
0.0
0.001
1
NIL
HORIZONTAL

INPUTBOX
1774
534
1834
594
cc-sd
15.0
1
0
Number

SWITCH
1688
266
1836
299
P_evo_decrease
P_evo_decrease
0
1
-1000

MONITOR
235
610
292
655
NIL
P_inc
6
1
11

MONITOR
302
609
385
654
NIL
P_full
7
1
11

PLOT
316
485
658
605
Histogram Slope
NIL
NIL
-1.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.1 1 -817084 true "" "histogram [t-dispersal-density-threshold] of turtles with [t-status = 1 or t-status = 2]"
"pen-1" 0.1 1 -7500403 true "" "histogram [w-dispersal-density-threshold]  of turtles with [t-status = 0]"

CHOOSER
20
607
158
652
loci
loci
1 2
1

SWITCH
1849
316
1974
349
P_full_exists
P_full_exists
1
1
-1000

INPUTBOX
1688
305
1843
365
P_full_set
0.001
1
0
Number

SWITCH
1886
136
2072
169
only_phenotypic_range
only_phenotypic_range
0
1
-1000

SWITCH
2594
414
2988
447
dispersal-density-updated-after-each-dispersal
dispersal-density-updated-after-each-dispersal
1
1
-1000

INPUTBOX
945
185
1106
245
ticks-when-t-comes-in
10000.0
1
0
Number

SWITCH
679
410
874
443
incremental-shuffle
incremental-shuffle
0
1
-1000

INPUTBOX
1843
536
1932
596
cc-sd-incr
15.0
1
0
Number

SWITCH
1687
227
1885
260
start_with_mutation
start_with_mutation
0
1
-1000

INPUTBOX
1679
78
1840
138
d0-dividedby
1000.0
1
0
Number

INPUTBOX
1682
148
1843
208
d1-dividedby
50000.0
1
0
Number

INPUTBOX
1689
377
1850
437
P_inc_final
0.001
1
0
Number

INPUTBOX
19
663
180
723
approach-alpha
0.02
1
0
Number

SWITCH
238
747
440
780
t-homozygous-fertile
t-homozygous-fertile
0
1
-1000

SWITCH
1895
218
2049
251
switch-turtles
switch-turtles
0
1
-1000

TEXTBOX
1699
12
1866
38
Advanced
20
0.0
1

TEXTBOX
1346
22
1513
48
Output
20
0.0
1

TEXTBOX
985
29
1152
55
Basics
20
0.0
1

TEXTBOX
429
620
596
646
Main variables
20
0.0
1

@#$#@#$#@
<https://github.com/jnrunge/t-vs-w-dispersal-evolution>
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="3.7.0-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarDriveVarTau" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.15"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.35"/>
      <value value="0.4"/>
      <value value="0.45"/>
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarDriveVarTau/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarDriveVarPtsperm" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarDriveVarPtsperm/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarTauVarAlpha-FreqExp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.0125"/>
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarTauVarAlpha-FreqExp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarDriveVarPtsperm-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarDriveVarPtsperm-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-more" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-more/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-more2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-more2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-more3" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-more3/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-more4" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-more4/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-more5" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-more5/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-NatCond-Heterogeneity-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-NatCond-Heterogeneity-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarDriveVarPtsperm-3" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarDriveVarPtsperm-3/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.1-1linloci-100K-VarTauVarAlpha-FreqExp-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.0125"/>
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;D:/ABM/3.7.1-1linloci-100K-VarTauVarAlpha-FreqExp-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-2-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-2-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-VarTauVarAlpha-3-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-VarTauVarAlpha-3-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarTauVarAlpha-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarTauVarAlpha-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-InfertileMalesVarAlpha-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-InfertileMalesVarAlpha-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarDriveVarPtsperm-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarDriveVarPtsperm-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarTauVarAlpha-FreqExp-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarTauVarAlpha-FreqExp-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-2linloci-1M-NatCond-Heterogeneity-2-LowerAlpha-371comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-2linloci-1M-NatCond-Heterogeneity-2-LowerAlpha-371comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-3" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-3/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-1linloci-100K-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-1linloci-100K-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-InfertileMalesVarAlpha-LowerAlpha-SwitchTIntoSim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-InfertileMalesVarAlpha-LowerAlpha-SwitchTIntoSim/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-1linloci-100K-VarDriveVarPtsperm-LowerAlpha-SwitchTIntoSim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-1linloci-100K-VarDriveVarPtsperm-LowerAlpha-SwitchTIntoSim/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-1linloci-100K-VarDriveVarTau-SwitchTIntoSim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.15"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.35"/>
      <value value="0.4"/>
      <value value="0.45"/>
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-1linloci-100K-VarDriveVarTau-SwitchTIntoSim/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-4" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-4/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-5" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-VarTauVarAlpha-LowerAlpha-SwitchTIntoSim-5/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-3" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-3/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-1linloci-100K-VarDriveVarPtsperm-LowerAlpha-SwitchTIntoSim-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-1linloci-100K-VarDriveVarPtsperm-LowerAlpha-SwitchTIntoSim-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-1linloci-100K-VarDriveVarTau-SwitchTIntoSim-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.15"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.35"/>
      <value value="0.4"/>
      <value value="0.45"/>
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-1linloci-100K-VarDriveVarTau-SwitchTIntoSim-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-InfertileMalesVarAlpha-LowerAlpha-SwitchTIntoSim-2" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-InfertileMalesVarAlpha-LowerAlpha-SwitchTIntoSim-2/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-4" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="10"/>
      <value value="20"/>
      <value value="25"/>
      <value value="0"/>
      <value value="5"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-4/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="10"/>
      <value value="20"/>
      <value value="25"/>
      <value value="0"/>
      <value value="5"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-5" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="10"/>
      <value value="20"/>
      <value value="25"/>
      <value value="0"/>
      <value value="5"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-5/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="10"/>
      <value value="20"/>
      <value value="25"/>
      <value value="0"/>
      <value value="5"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-6" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="10"/>
      <value value="20"/>
      <value value="25"/>
      <value value="0"/>
      <value value="5"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-6/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="10"/>
      <value value="20"/>
      <value value="25"/>
      <value value="0"/>
      <value value="5"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.0-1linloci-100K-VarTauVarAlpha-FreqExp-LowerAlpha-2-372comp" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0"/>
      <value value="0.01"/>
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.0-1linloci-100K-VarTauVarAlpha-FreqExp-LowerAlpha-2-372comp/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-7" repetitions="30" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count-w</metric>
    <metric>count-t</metric>
    <metric>count-tt</metric>
    <metric>count-w + count-t + count-tt</metric>
    <enumeratedValueSet variable="min-pxcor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-pycor">
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pxcor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-pycor">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="matings-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-2">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_set">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-viability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver-start">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-starting-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-ticks">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="geno-ids-print-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-start">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-fidelity">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches-timing">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-patches">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-density-dependent-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_set">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-random">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-juvenile-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="evolve-dispersal">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fecundity-global">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-cost">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-effect">
      <value value="&quot;dominant&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="drive">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-mean">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="end-with-t?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd">
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-dd-evolver-3">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_evo_decrease">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="extended-disadvantage-adaptation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-death">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="approach-alpha">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-number">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="loci">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-prob">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-fecundity">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-mod-evolver">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="smart-report-geno">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-report">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="file-location">
      <value value="&quot;/moto/ziab/users/jr3950/data/ABM/3.7.2-2linloci-1M-NatCond-Heterogeneity-LowerAlpha-SwitchTIntoSim-7/&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_full_exists">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="w-advantage">
      <value value="0.85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only_phenotypic_range">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dispersal-density-updated-after-each-dispersal">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ticks-when-t-comes-in">
      <value value="100000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cc-sd-incr">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incremental-shuffle">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="start_with_mutation">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d0-dividedby">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="d1-dividedby">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="P_inc_final">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="t-homozygous-fertile">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="switch-turtles">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
