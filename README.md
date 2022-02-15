# Simulation of meiotic driver vs wildtype dispersal propensity

LICENSE: CC BY-NC 4.0 https://creativecommons.org/licenses/by-nc/4.0/

This repository hosts the raw simulation code, written for NetLogo 6.1.1, of the publication "Selfish migrants: How a meiotic driver is selected to increase dispersal" by Jan-Niklas Runge, Hanna Kokko, and Anna K. Lindholm ([bioRxiv](https://www.biorxiv.org/content/10.1101/2021.02.01.429134v3.full)). It generated data that was analyzed and can be found at [Zenodo](https://zenodo.org/record/4486286). A simplified online version can be played with on my [homepage](https://janniklasrunge.de/model.html).

model.nlogo is the main file, model_online.nlogo is just a derivative with some interface and default value adjustments for browser usage.

Here is what this model does, briefly, and not meant to replace what the paper and associated data upload explain.

The model places wildtype "mice" with randomized dispersal propensities into a world made of patches with random carrying capacities. Dispersal propensities, the probability of emigrating from the natal patch as a juvenile, are inherited from parents to offspring and can mutate, i.e. there is evolution of this trait. At a later point, some (default half) the mice are changed to carry the *t* haplotype, a meiotic driver in house mice, heterozygously. These mice continue with their previous dispersal propensities, but now half the dispersal propensity loci are associated with the *t* haplotype and transmitted with it. This means that effectively two genotypes (*t* and the wildtype) are selected to optimize (their) dispersal propensities. The resulting (after some time) differences (or not) in dispersal between the two genotypes are then monitored with this model. The influence of several variables on this difference can then be systematically investigates, which is what we did in the paper.

The model contains several built-in variables:

* approach-alpha: $\alpha$ in the paper; probability of an already mated female to mate with the next approaching male, i.e. a female will mate with $1+(n-1)\alpha$ males if there are $n$ eligible males, per turn.
* cc-mean: Mean carrying capacity of patches.
* cc-sd-incr: Standard deviation around the current carrying capacity used to redraw the carrying capacity (incremental changes in CC over time)
* cc-sd: Standard deviation around cc-mean used to draw the initial carrying capacities
* d0-dividedby: Size of the incremental mutations of $D_0$ - dispersal-mod-evolver / d0-divdedby = $\pm$ step of one mutation.
* d1-dividedby: Size of the incremental mutations of $D_1$ - dispersal-dd-evolver / d1-divdedby = $\pm$ step of one mutation.
* death-prob: Probability of a mouse to die every turn
* density-death: true / false; can mice die *due to density*, i.e. carrying capacity has an effect.
* density-fecundity: true / false; does density (distance to carrying capacity) impact fecundity, i.e. litter size
* dispersal-cost: Mortality probability of dispersal.
* dispersal-dd-evolver-start: Starting value of $D_1$, usually made redundant due to start_with_mutation.
* dispersal-dd-evolver: Range of $D_1$ (0 to $\pm$ this value).
* dispersal-density-updated-after-each-dispersal: Do mice know the current density when they evaluate dispersal or do all mice know the initial density (in that turn/tick)?
* dispersal-mod-evolver-start: Starting value of $D_0$, usually made redundant due to start_with_mutation.
* dispersal-mod-evolver: Range of $D_1$ (0 to $\pm$ this value, unless only_phenotypic_range, then only 0 to this value)
* drive: % of sperm of +/*t* male being *t*.
* end-with-t?: End simulation when *t* dies out.
* evolve-dispersal: Do we even evolve dispersal?
* extended-disadvantage-adaptation: Alternative option that allows for running the simulation until max-ticks and instead of stopping increases w-advantage until 1 or until *t* dies out. Idea of this is to test what happens when polyandry slowly becomes worse for *t*, something that may or may not have happened during *t* evolution. Not published or systematically tested.
* fecundity-global: How many offspring per pregnant female?
* fecundity-random: Is there an additional range of offspring where females carry randomly fecundity-global + 0 to fecundity-random offspring?
* file-location: Where to save optional output files (directory)?
* geno-ids-print-interval: How often to query current genotypes and write to output (gets quite large, so not every turn ideally).
* incremental-shuffle: Are patches changing their carrying capacity incrementally (see cc-sd-incr)
* loci: How many loci determine dispersal propensity (1 = locus value is propensity; 2 = one locus is intercept and the other is slope vs density)
* matings-report: Write output file on matings.
* max-pxcor: World coordinates / size
* max-pycor: World coordinates / size
* max-ticks: How long the simulation should run
* min-pxcor: World coordinates / size
* min-pycor: World coordinates / size
* new-density-dependent-dispersal: Historic setting, keep to true
* only_phenotypic_range: Should $D_0$ not be below 0?
* only-juvenile-dispersal: Only mice age 1 can disperse
* P_evo_decrease: Mutation probabilities decrease from P_inc_set to P_inc_final and in a more complex and unused way similarly for P_full if P_full_exists.
* P_full_exists: Do full mutations (random new value within range independent of former dispersal propensity) exist?
* P_full_set: Full mutation probability, but complicated if P_evo_decrease, not supported / used in paper.
* P_inc_final: Incremental mutation probability at ticks-when-t-comes - 1 in and max-ticks
* P_inc_set: Incremental mutation probability at ticks=0 and ticks=ticks-when-t-comes
* patch-fidelity: Color-coding patches in the live viewer according to *t* frequency, used in the online model and for fun.
* patches-report: Output patch report files?
* shuffle-patches-timing: How often are patches changing carrying capacity?
* shuffle-patches: Do patches change carrying capacities?
* smart-report-geno: Report genotype values (output)?
* start_with_mutation: Do we start with a full mutation, i.e. random dispersal propensities at tick=0 / initialization?
* starting-number: How many mice are dropped into the world at beginning? Just needs enough and then will quickly solve itself.
* switch-turtles: Do mice "switch" genotypes at ticks-when-t-comes-in or are new mice placed into the world?
* t-effect: dominant or additive (dispersal propensities)
* t-homozygous-fertile: Can male *t*/*t* produce fertile sperm?
* t-homozygous-viability: Chance of *t*/*t* embryo being viable.
* t-starting-frequency: Frequency of +/*t* at beginning of simulation; 1 means 0 in this case, otherwise value is in percent.
* ticks-when-t-comes-in: When are *t* placed in the simulation, can AFAIK conflict with t-starting-frequence != 1; 0 means off.
* w-advantage: Fraction of pups sired by +/+ male in completion with one +/*t* male in a polyandrous mating.
