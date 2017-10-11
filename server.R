shinyServer(function(input, output,session) {
        mapdata <- reactive({
                grand %>%
                        filter(hour_ >= input$range[1] &
                                hour_ <= input$range[2])
        })
        
        
        output$dist_time  <- renderPlot({
                compid %>% group_by(vendor_id) %>% ggplot(aes(dist,trip_duration)) + 
                        geom_point(aes(colour = hour_)) + 
                        geom_density2d() + 
                        facet_grid(. ~ vendor_id) + 
                        scale_color_gradient(low ="green", high = "red") + 
                        theme(legend.position = "right") + 
                        scale_x_continuous(limits = c(0,30))+
                        ggtitle("Distribution Trip Length for The Two Vendors")+
                        theme_light()+
                        theme(legend.position="bottom")
                        
        })
        
        output$wkday  <- renderPlot({
                compid %>% mutate(hr = hour(pickup_datetime),wkday = factor(wday(pickup_datetime, label = TRUE))) %>%
                        group_by(vendor_id, hr,wkday) %>% 
                        summarise(tripmean = mean(trip_duration), tripmed = median(trip_duration)) %>%
                        ggplot(aes(hr,tripmed,color = wkday)) +
                        geom_line(size = .75) + 
                        labs(x = "Hour of the day", y = "count") + 
                        facet_grid(vendor_id ~ .) +
                        theme_light() 
                
        })
        
        output$vend  <- renderPlot({
                compid %>% group_by(vendor_id) %>% 
                        ggplot(aes(pickup_longitude,pickup_latitude)) +
                        geom_point(aes(color = trip_duration)) + 
                        scale_color_gradient(low ="yellow", high = "black") +
                        facet_grid(. ~ vendor_id)
                
        })
        output$vid_dist  <- renderPlot({
                ggplot(data = compid, aes(group = vendor_id, x= vendor_id, y = trip_duration)) + 
                        geom_violin() +
                        geom_boxplot(aes(fill = vendor_id)) + 
                        facet_grid(. ~ vendor_id) + scale_y_log10()+
                        theme_light()+ ggtitle("Boxplot of Trip Duration for the Two Vendors")+
                        theme(legend.position="bottom")
                
        })
        
        output$plot1  <- renderPlot({
                hist1 <-final[seq_len(input$slider)]
                hist1 %>% 
                        group_by(vendor_id) %>% 
                        ggplot(aes(trip_duration)) +
                        geom_histogram(fill = "light blue", bins = 200) + 
                        scale_x_log10() + scale_y_sqrt() +
                        theme_light() +
                        facet_grid(. ~ vendor_id) + ggtitle("Histogram of Trip Duration for the Two Vendors")
        })
        
        output$plot2  <- renderPlot({
                hist1 <-final[seq_len(input$slider)]
                hist1 %>% 
                        group_by(vendor_id,passenger_count) %>% 
                        count() %>%ggplot(aes(passenger_count, n, fill = passenger_count)) + 
                        geom_col() + 
                        scale_y_sqrt() + 
                        theme(legend.position = "right", legend.title.align = "vertical") + 
                        facet_grid(. ~ vendor_id) + 
                        theme(axis.text.x=element_text(angle=-90,hjust=1)) +
                        theme_light() +
                        ggtitle("Barplot of Trip Duration for the Two Vendors")
        })
        
        output$plot3  <- renderPlot({
                hist1 <-final[seq_len(input$slider)]
                hist1 %>%
                        group_by(vendor_id,passenger_count) %>%
                        summarise(trip_med = median(trip_duration)) %>% 
                        ggplot(aes(passenger_count, trip_med, fill = passenger_count)) +
                        geom_col() +scale_y_sqrt() + 
                        theme(legend.position = "right") + 
                        facet_grid(. ~ vendor_id) + 
                        theme(axis.text.x=element_text(angle=-90,hjust=1)) +
                        theme_bw()
        })
        output$plot4  <- renderPlot({
                mapdata() %>%
                        group_by(mapdata()$vendor_id,mapdata()$passenger_count) %>%
                        ggplot(aes(mapdata()$hour_, mapdata()$trip_duration, fill = mapdata()$hour_)) +
                        geom_col() + 
                        theme(legend.position = "right") + 
                        facet_grid(. ~ mapdata()$vendor_id) +
                        theme_light()
        })
        
        
        output$mapping <- renderLeaflet({
                
                leaflet(data = mapdata()) %>% 
                addProviderTiles("Esri.NatGeoWorldMap") %>%
                addWebGLHeatmap(lng = mapdata()$pickup_longitude, lat = mapdata()$pickup_latitude, size = 200, opacity = 0.7) %>%
                setView(-73.9846, 40.7528, zoom = 12)
        })
        
        output$table <- DT::renderDataTable({
                datatable(final, rownames=FALSE) %>% 
                        formatStyle(input$selected,  
                                    background="skyblue", fontWeight='bold')
        })

})

                































# leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
#         addMarkers(lng=-73.9846, lat=40.7528, popup="New York City")%>%
#         setView(-73.9846, 40.7528, zoom = 12)
# leaflet() %>%
#         addProviderTiles(providers$Stamen.TonerLite,
#                          options = providerTileOptions(noWrap = TRUE)
#         ) %>%
#         addMarkers(data = points(lng=-74.0059, lat=40.7128, popup="New York City"))
# output$regSale<- renderPlot({ggplot(VGdata, aes_string(
#         x = input$reg1, y= input$reg2)) + geom_point(aes(color=Genre)) +geom_smooth()})
# output$avgGscore <- renderPlot({ggplot(genreAvgScore, aes(x=Genre, y=scores, fill = type, group =type)) + geom_bar(
#         stat='identity', position = 'dodge') + ggtitle('Average Genre Review Scores')})
# output$wordc <- renderPlot({comparison.cloud(BestSellerM, colors=brewer.pal(length(levels(BestSeller$Genre)), "Paired"), scale=c(3,0.5), title.size = 1)})
# output$ConsoleComp <- renderPlot({ggplot(bigThree, aes(x=factor(1), y=Total_Sales, fill = companyPlatform)) + geom_bar(stat = 'Identity')+ coord_polar(theta='y')+ theme(axis.title.y=element_blank(),
#                                                                                                                                                                          axis.text.y=element_blank(),
#                                                                                                                                                                          axis.ticks.y=element_blank(),
#                                                                                                                                                                          axis.ticks.x=element_blank(),
#                                                                                                                                                                          axis.text.x=element_blank())+ ggtitle('Distribution of Sales Across Regions') +ylab('Sales Distribution')})
# output$ConsoleComp1 <- renderPlot({ggplot(bigThree, aes(x=factor(1), y=Total_Users, fill = companyPlatform)) + geom_bar(stat = 'Identity')+ coord_polar(theta='y')+ theme(axis.title.y=element_blank(),
#                                                                                                                                                                           axis.text.y=element_blank(),
#                                                                                                                                                                           axis.ticks.y=element_blank(),
#                                                                                                                                                                           axis.ticks.x=element_blank(),
#                                                                                                                                                                           axis.text.x=element_blank()) + ggtitle('Users Count Across Regions')+ylab('Number of User Reviews')})
# output$topTwoGenre <- renderPlot({ggplot(YearTopTwoGenre, aes(x=Year_of_Release, y=total.genre.sales)) + geom_bar(stat='Identity', aes(fill=Genre))})
# output$topTwoPlat <- renderPlot({ggplot(YearTopTwoPlat, aes(x=Year_of_Release, y=total.plat.sales)) + geom_bar(stat='Identity', position = 'stack', aes(fill=Platform))+xlab(
#         'Year of Release') + ylab('Units Sold in Millions') + ggtitle('Top Two Console Games Sold')})
# output$YearRegionSales <-renderPlot({ggplot(data = tot_region_sales, aes(x = Year_of_Release)) + geom_line(aes(y=tot_NA_sales, colour = 'NA Sales'))+ geom_line(aes(y=tot_EU_sales, colour = 'EU Sales')) + geom_line(aes(y=tot_JP_sales, colour = 'JP Sales')) + xlab(
#         'Units sold in Millions') + ylab('Year of Release') + ggtitle('Regional Units Sold Comparison')
# })
# 
# output$radar <-renderPlot({ggradar(scaled_bigThree) +  ggtitle('Regional Performance of Consoles')})
# output$table <-renderDataTable({
#         datatable(VGdata, rownames=FALSE) %>% 
#                 formatStyle(input$selected,  
#                             background="skyblue", fontWeight='bold')})
# 
