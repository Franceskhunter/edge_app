library(shiny)

fluidPage(
    titlePanel("Uploading Files"),
    sidebarLayout(
        sidebarPanel(
            fileInput('phy', 'Choose Phylogeny (Newick)', accept=c('.tre','.phy')),
            fileInput('redlist', 'Choose Threat data (CSV)', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
            tags$hr(),
            h1("How to use this app"),
            p("1. Upload a phylogeny in Newick format (first button above). This will automatically be imputed to contain any missing species using the 'congeneric.merge' merge/replace method."),
            tags$a(href="https://github.com/willpearse/edge_app/raw/master/test.tre", "For an example of a mammal phylogeny in Newick format, click here!"),
            p("3. Upload the threat information for each species. This should contain IUCN Red List scores, either as numbers (following Isaac et al. 2006) or as text (e.g., 'least concern', etc.) (second button above). The first column should be species' names (genus_species), the second the IUCN score, and there should be only one entry per species."),
            tags$a(href="https://github.com/willpearse/edge_app/raw/master/test.csv", "For an example of the format for mammals, click here!"),

            p("Once you've done this, there will be a slight delay, and then classic EDGE and EDM scores (along with the ED values upon which they are based) will be returned."),
            h1("Citations"),
            p("Isaac NJB, Turvey ST, Collen B, Waterman C, Baillie JEM (2007) Mammals on the EDGE: Conservation Priorities Based on Threat and Phylogeny. PLoS ONE 2(3): e296. doi:10.1371/journal.pone.0000296 (EDGE)"),
            p("Pearse WD, Chase MW, Crawley MJ, Dolphin K, Fay MF, Joseph JA, et al. (2015) Beyond the EDGE with EDAM: Prioritising British Plant Species According to Evolutionary Distinctiveness, and Accuracy and Magnitude of Decline. PLoS ONE 10(5): e0126524. doi:10.1371/journal.pone.0126524 (EDM)"),
            p("David Orme, Rob Freckleton, Gavin Thomas, Thomas Petzoldt, Susanne Fritz, Nick Isaac and Will Pearse (2013). caper: Comparative Analyses of Phylogenetics and Evolution in R. R package version 0.5.2. https://CRAN.R-project.org/package=caper (internal R package)")
        ),
        mainPanel(
            verbatimTextOutput('congeneric.merge'),
            tags$hr(),
            verbatimTextOutput('metadata'),
            tags$hr(),
            tableOutput('edge.results')
        )
    )
)

