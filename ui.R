shinyUI(dashboardPage(
        
        dashboardHeader(title = 'NYC Taxi Vendor Drive Time Analysis', titleWidth = 400),
        
        dashboardSidebar(
                sidebarUserPanel("My Dashboard"),
                sidebarMenu(
                        sidebarMenuOutput("whatever"),
                        menuItem("Introduction", tabName = "markdown"),
                        menuItem("Map", tabName = "map", icon = icon("map")),
                        menuItem("Plots", tabName = "plots"),
                        menuItem("Distance v/s Time", tabName = "dist_time"),
                        menuItem("Data", tabName = "data", icon = icon("database")),
                        selectizeInput("selected",
                                                 "Select Item to Display",
                                                 choice)
                        )
       ,width = 300 ),
        
        dashboardBody(
                tabItems(
                        tabItem(tabName = "markdown", h1(img(src="nyctaxi.jpg", height = 400, width = 800)),
                                h1(class = 'text-muted','"Processed data is information.\n 
                                   Processed information is knowledge.\n 
                                   Processed knowledge is Wisdom.”  (Ankala V. Subbarao)'
                                   ),
                                p(class = "text-muted",paste(""))
                                ),
                        
                        tabItem(tabName = "dist_time", 
                                fluidRow(
                                        box(title = "Distance Vs Time N-S bound Traffic", status = "primary", plotOutput('dist_time', width = 600,height = 300)),
                                        box(title = "Scat 2", status = "primary", plotOutput('wkday', width = 600,height = 300)),
                                        box(title = "Scat 3", status = "primary", plotOutput('vid_dist', width = 600,height = 300)),

                                p(class = "text-muted",paste("")
                                ))),
                        
                        tabItem(tabName = "plots",
                                fluidRow(
                                        status = "primary", plotOutput("plot1", width = 1200,height = 230),
                                        status = "primary", plotOutput("plot2", width = 1200,height = 230),
                                        status = "primary", plotOutput("plot3", width = 1200,height = 230),
                                        sliderInput("slider", "Number of Observations:", 1, nrow(test), 100000, width = 1200
                                        ))),
                        
                        tabItem(tabName = "map",
                                leafletOutput(outputId = "mapping", width = 1200, height = 450),
                                status = "primary", plotOutput("plot4", width = 1200,height = 270),
                                sliderInput("range", "Time of the Day (Range: 3hrs",
                                                min = 1, max = 24,
                                                value = c(7,10), width = 1200)
                                # checkboxInput("show", "Trip Duration ID-1", value = FALSE),
                                # checkboxInput("show", "Trip Duration ID-2", value = FALSE)
                        ),
                        
                        tabItem(tabName = "data",
                                # datatable
                                fluidRow(box(DT::dataTableOutput("table"))))
                                
                        )
                )
        )
)


