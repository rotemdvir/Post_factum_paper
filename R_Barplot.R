## Post factum paper
## Events plot
## Rotem Dvir, June 2020

setwd("~/Dropbox/TAMU/Extra_Projects/Git_edits/post_factum")

library(ggplot2)
library(tidyverse)
library(ggpubr)

##  Build dataset of total events, by month and by type
dat1 = data.frame(
  date=factor(c("01/87", "02/87", "03/87", "04/87", "05/87", 
                "06/87", "07/87", "08/87", "09/87", "10/87", 
                "11/87", "12/87")),
  variable=c(9, 0, 1, 7, 5, 5, 20, 7, 4, 14, 7, 23, 3, 0, 1, 0, 0, 
             1, 7, 4, 0, 9, 0, 18), levels=c("Violent", "Violent", "Violent", "Violent", "Violent", "Violent", 
                                             "Violent", "Violent", "Violent", "Violent", "Violent", "Violent", 
                                             "Nonviolent", "Nonviolent", "Nonviolent", "Nonviolent", 
                                             "Nonviolent", "Nonviolent", "Nonviolent", "Nonviolent", 
                                             "Nonviolent", "Nonviolent", "Nonviolent", "Nonviolent"))

# Two columns PLOT
g_barplot <- ggplot(data=dat1, aes(x=date, y=variable, fill=levels)) +
  geom_bar(stat="identity", position=position_dodge()) +  
  xlab("1987 Months") +
  ylab("Number of Events") +
  theme_pubr() +
  labs(fill = "Event Type") + 
  ggtitle("1987: All Events, by type")

g_barplot + theme(
  plot.title = element_text(size = 18, face = "bold.italic")) +
  scale_fill_brewer(palette="Set1")


## Stacked plot
s_barplot <- ggplot(dat1, aes(x=date, y=variable, fill=levels)) +
  geom_bar(stat="identity") +
  xlab(" 1987 Months") +
  ylab("Number of Events") +
  theme_pubr() +
  labs(fill = "Event Type") + 
  ggtitle("1987: All Events, by type")

s_barplot + theme(
  plot.title = element_text(size = 18, face = "bold.italic")) +
  scale_fill_brewer(palette="Set1")
