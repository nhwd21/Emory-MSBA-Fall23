# Setup -------------------------------------------------------------------

library(ggplot2)
library(dplyr)
library(patchwork)

talent_flows <- read.csv("talent_flows.csv")


# Chart 1 -----------------------------------------------------------------

# The top left chart shows the top 10 companies with the highest number of incoming employees

tmp <- setNames(
  aggregate(migration_count ~ to, talent_flows, sum),
  c("to", "migration_count")
)

tmp$rank <- rank(tmp$migration_count)
tmp <- arrange(tmp, desc(rank))
tmp <- filter(tmp, rank > 463)

p1 <- ggplot(tmp) + geom_col(mapping=aes(to, migration_count)) + coord_flip() +
  labs(y="Total number of incoming employees",
       title="Top 10 Companies with the highest number of incoming employees",
       x="Company")
p1


# Chart 2 -----------------------------------------------------------------

# The top right chart shows the top 10 companies with the highest number of outgoing employees

tmp2 <- setNames(
  aggregate(migration_count ~ from, talent_flows, sum),
  c("to", "migration_count")
)

tmp2 <- arrange(tmp2, desc(migration_count))
tmp2 <- filter(tmp2, migration_count > 21000)

p2 <- ggplot(tmp2) + geom_col(mapping=aes(to, migration_count)) + coord_flip() +
  labs(y="Total number of outgoing employees",
       title="Top 10 Companies with the highest number of outgoing employees",
       x="Company")
p2


# Chart 3 -----------------------------------------------------------------

#The bottom left chart shows the top 10 companies with the highest net gain 
# of employees (net = incoming - outgoing employees)

# I was struggling with the aggregation here and on the next graph

tmp3 <- talent_flows

tmp3 <- setNames(
  aggregate(talent_flows$migration_count, list(total_in = talent_flows$to, total_out = talent_flows$out), sum),
  c("company", "net_change")
)

tmp2 <- arrange(tmp2, desc(migration_count))
tmp2 <- filter(tmp2, migration_count > 21000)

p3 <- ggplot(tmp3) + geom_col(mapping=aes(company, net_change)) + coord_flip() +
  labs(y="Total number of outgoing employees",
       title="Top 10 Companies with the highest Net Gain of employees",
       x="Company")
p


# Final -------------------------------------------------------------------


finalplot <- (p1 + p2)
finalplot <- finalplot + plot_annotation(
  title = 'Talent Flows between S&P 500 Companies',
  subtitle = 'Foster Mosden'
)
finalplot
