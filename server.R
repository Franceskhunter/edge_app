library(shiny)
library(caper)
library(pez)

function(input, output) {
    output$edge.results <- renderTable({
        # Load data and impute
        if(!is.null(input$tree)){
            tree <- read.tree(input$phy$datapath)
            tree$tip.label <- tolower(tree$tip.label)
            tree$tip.label <- gsub(" ", "_", tree$tip.label)
        }
        if(!is.null(input$redlist)){
            data <- read.csv(input$redlist$datapath, as.is=TRUE)
            names(data)[1] <- "species"; names(data)[2] <- "redlist"
            output$congeneric.merge <- renderText(
                paste("Congeneric merge details:", paste(capture.output(tree <- congeneric.merge(tree, data$species)), collapse="\t\n"), collapse="\n")
            )
            
            # Setup Redlist scores
            data$redlist <- tolower(as.character(data$redlist))
            data$redlist <- gsub("lc|(least concern)", "0", data$redlist)
            data$redlist <- gsub("nt|cr|(near threatened)|(conservation dependent)", "1", data$redlist)
            data$redlist <- gsub("vu|(vulnerable)", "2", data$redlist)
            data$redlist <- gsub("en|(endangered)", "3", data$redlist)
            data$redlist <- gsub("cr|(critically endangered)", "4", data$redlist)
            data$redlist <- as.numeric(data$redlist)
            
            # Create comparative.data
            c.data <- comparative.data(tree, data, species)
            output$metadata <- renderText(
                paste0("Dataset details:", "\n", paste(capture.output(print(c.data)), collapse="\t\n"))
            )

            # Calculate        
            ed <- ed.calc(c.data$phy)$spp
            output <- data.frame(
                species=ed$species,
                ED=ed$ED,
                redlist=c.data$data$redlist,
                edge=log(ed$ED+1) + c.data$data$redlist*log(2),
                edm = as.numeric(scale(log(ed$ED))) + as.numeric(scale(c.data$data$redlist*log(2)))
            )
            output$top.edge.species <- with(output, ED > median(ED) & redlist>1)
            return(output)
        }
    })
}
