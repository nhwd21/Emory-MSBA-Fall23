# Boxplot Walkthrough in ggplot2
library(datasets)
library(ggplot2)
data(airquality)
airquality$Month <- factor(airquality$Month,
                           labels = c("May", "Jun", "Jul", "Aug", "Sep"))

p1 <- ggplot(airquality, aes(x = Month, y = Ozone)) +
  geom_boxplot()
p1
## Warning: Removed 37 rows containing non-finite values (stat_boxplot).

(p1 <- p1 + scale_y_continuous(name = "Mean ozone in\nparts per billion",
                               breaks = seq(0, 175, 25),
                               limits=c(0, 175)) +
    ggtitle("Boxplot of mean ozone by month"))
## Warning: Removed 37 rows containing non-finite values (stat_boxplot).

fill <- "#4271AE" # Hex color code
line <- "#1F3552" # Hex color code
# see Hex Color Picker:https://www.w3schools.com/colors/colors_picker.asp
(p1 <- ggplot(airquality, aes(x = Month, y = Ozone)) +
    geom_boxplot(fill = fill, colour = line, alpha = 0.7,
                 outlier.colour = "#1F3552", outlier.shape = 20) +
    scale_y_continuous(name = "Mean ozone in\nparts per billion",
                       breaks = seq(0, 175, 25),
                       limits=c(0, 175)) +
    scale_x_discrete(name = "Month") +
    ggtitle("Boxplot of mean ozone by month"))
## Warning: Removed 37 rows containing non-finite values (stat_boxplot).

p1 <- ggplot(airquality, aes(x = Month, y = Ozone)) +
  geom_boxplot(fill = fill, colour = line, notch=TRUE, alpha = 0.7,
               outlier.colour = "#1F3552", outlier.shape = 20) +
  scale_y_continuous(name = "Mean ozone in\nparts per billion",
                     breaks = seq(0, 175, 25),
                     limits=c(0, 175)) +
  scale_x_discrete(name = "Month") +
  ggtitle("Boxplot of mean ozone by month") + geom_jitter() + theme_bw(
  )
p1
## Warning: Removed 37 rows containing non-finite values (stat_boxplot).
## notch went outside hinges. Try setting notch=FALSE.

airquality_trimmed <- airquality[which(airquality$Month == "Jul" |
                                         airquality$Month == "Aug" |
                                         airquality$Month == "Sep"), ]
airquality_trimmed$Temp.f <- factor(ifelse(airquality_trimmed$Temp > 
                                             mean(airquality_trimmed$Temp), 1, 0), labels = c("Low temp", "High temp"))

# install RColorBrewer if needed
library(RColorBrewer)
p1 <- ggplot(airquality_trimmed, aes(x = Month, y = Ozone, fill = Temp.f)) +
  geom_boxplot(alpha=0.7) +
  scale_y_continuous(name = "Mean ozone in\nparts per billion",
                     breaks = seq(0, 175, 25),
                     limits=c(0, 175)) +
  scale_x_discrete(name = "Month") +
  ggtitle("Boxplot of mean ozone by month") +
  theme_bw() +
  theme(plot.title = element_text(size = 14, family = "Tahoma", face =
                                    "bold"),
        text = element_text(size = 12, family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x=element_text(size = 11),
        legend.position = "bottom") +
  scale_fill_brewer(palette = "Accent") +
  labs(fill = "Temperature")
p1
## Warning: Removed 11 rows containing non-finite values (stat_boxplot).


# ECDFs in ggplot2
library(ggplot2)
## Warning in as.POSIXlt.POSIXct(Sys.time()): unknown timezone 'zone/tz/2020a

## 1.0/zoneinfo/America/New_York'
set.seed(1234)
df <- data.frame(height = round(rnorm(200, mean=60, sd=15)))
head(df)
## height
## 1 42
## 2 64
## 3 76
## 4 25
## 5 66
## 6 68
ggplot(df, aes(height)) +
  geom_histogram(alpha = 0.5)
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

# Basic ECDF plot
ggplot(df, aes(height)) +
  stat_ecdf(geom = "step") +
  labs(title="Empirical Cumulative Density Function",
       y = "F(height)", x="Height in inches")+
  geom_vline(aes(xintercept = quantile(height)[2]), linetype="dashed") + #first quartile
geom_vline(aes(xintercept = quantile(height)[4]), linetype="dashed")+ #third quartile
geom_hline(yintercept=0.25, linetype="dashed")+
  geom_hline(yintercept=0.75, linetype="dashed")+
  theme_classic()

library(gcookbook)
#View(tophitters2001)
#histogram
ggplot(tophitters2001, aes(avg, fill=lg)) +
  geom_histogram(alpha = 0.5)
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

#violin plot
ggplot(tophitters2001, aes(factor(lg), avg)) +
  geom_violin(aes(fill=lg)) +
  geom_jitter(width=0.10)

#Swarmplot
#install.packages("ggbeeswarm")
library(ggbeeswarm)
ggplot(tophitters2001, aes(lg, avg)) +
  geom_beeswarm(aes(color=lg))

##ECDF for TopHitters2001
ggplot(tophitters2001, aes(avg)) +
  stat_ecdf(geom = "step", aes(color=lg)) +
  geom_hline(aes(yintercept=0.5), linetype="dashed") +
  geom_vline(data=subset(tophitters2001, lg=="AL"), aes(xintercept=quantile(avg)[3]),
             linetype="dashed") +
  geom_vline(data=subset(tophitters2001, lg=="NL"), aes(xintercept=quantile(avg)[3]),
             linetype="dashed") +
  labs(title="MLB Top Hitter 2001 Batting Averages",
       y = "ECDF", x="Batting Average") +
  scale_x_continuous(breaks=seq(0.220, 0.350, 0.005),
                     labels=function(x){sprintf("%.3f", x)}) +
  scale_color_discrete("League") +
  theme_light()