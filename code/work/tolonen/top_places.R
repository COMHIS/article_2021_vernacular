estc <- dd$estc

estc <- estc %>% filter(publication_year < 1801)
estc <- estc %>% filter(publication_year > 1650)

snb <- dd$snb

snb <- snb %>% filter(publication_year < 1801)
snb <- snb %>% filter(publication_year > 1650)

fnb <- dd$fnb

fnb <- fnb %>% filter(publication_year < 1801)
fnb <- fnb %>% filter(publication_year > 1650)

stcn <- dd$stcn

stcn <- stcn %>% filter(publication_year < 1801)
stcn <- stcn %>% filter(publication_year > 1650)


### let's plot these together in some sense language

## estc

af1 <- estc %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(af1$language_primary)))[1:5])

af2 <- af1 %>% filter(language_primary %in% names(top))

# snb

bf1 <- snb %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(bf1$language_primary)))[1:5])

bf2 <- bf1 %>% filter(language_primary %in% names(top))

# fnb

cf1 <- fnb %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(cf1$language_primary)))[1:5])

cf2 <- cf1 %>% filter(language_primary %in% names(top))

# stcn

df1 <- stcn %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(df1$language_primary)))[1:5])

df2 <- df1 %>% filter(language_primary %in% names(top))

### combining

myvars <- as.vector(c("publication_year", "language_primary", "n"))
a1 = af2[myvars]
b1 = bf2[myvars]
c1 = cf2[myvars]
d1 = df2[myvars]

a1$cat <- "estc"
b1$cat <- "snb"
c1$cat <- "fnb"
d1$cat <- "stcn"

g1 <- rbind(a1, b1, c1, d1)

### plotting

ggplot(g1, aes(x=publication_year, y=n, group=language_primary, colour=language_primary)) +
  geom_line(aes(color=language_primary)) +
  scale_x_continuous(breaks = seq(from = 1500, to = 1800, by = 50))+
  facet_wrap(~cat, scales = "free") 

### latin vs. other percentages / not absolute numbers but just per decade comparisons

#### top places sama idea

af1 <- estc %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(af1$language_primary)))[1:5])

af2 <- af1 %>% filter(language_primary %in% names(top))

# snb

bf1 <- snb %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(bf1$language_primary)))[1:5])

bf2 <- bf1 %>% filter(language_primary %in% names(top))

# fnb

cf1 <- fnb %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(cf1$language_primary)))[1:5])

cf2 <- cf1 %>% filter(language_primary %in% names(top))

# stcn

df1 <- stcn %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(df1$language_primary)))[1:5])

df2 <- df1 %>% filter(language_primary %in% names(top))

### combining

myvars <- as.vector(c("publication_year", "language_primary", "n"))
a1 = af2[myvars]
b1 = bf2[myvars]
c1 = cf2[myvars]
d1 = df2[myvars]

a1$cat <- "estc"
b1$cat <- "snb"
c1$cat <- "fnb"
d1$cat <- "stcn"

g1 <- rbind(a1, b1, c1, d1)

### plotting

ggplot(g1, aes(x=publication_year, y=n, group=language_primary, colour=language_primary)) +
  geom_line(aes(color=language_primary)) +
  scale_x_continuous(breaks = seq(from = 1500, to = 1800, by = 50))+
  facet_wrap(~cat, scales = "free") 

### latin vs. other percentages / not absolute numbers but just per decade comparisons

#### top places sama idea

af1 <- estc %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(af1$language_primary)))[1:5])

af2 <- af1 %>% filter(language_primary %in% names(top))

# snb

bf1 <- snb %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(bf1$language_primary)))[1:5])

bf2 <- bf1 %>% filter(language_primary %in% names(top))

# fnb

cf1 <- fnb %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(cf1$language_primary)))[1:5])

cf2 <- cf1 %>% filter(language_primary %in% names(top))

# stcn

df1 <- stcn %>% group_by(publication_year, language_primary) %>%
  arrange(publication_year) %>%
  summarize(n = n())

top <- rev(rev(sort(table(df1$language_primary)))[1:5])

df2 <- df1 %>% filter(language_primary %in% names(top))

### combining

myvars <- as.vector(c("publication_year", "language_primary", "n"))
a1 = af2[myvars]
b1 = bf2[myvars]
c1 = cf2[myvars]
d1 = df2[myvars]

a1$cat <- "estc"
b1$cat <- "snb"
c1$cat <- "fnb"
d1$cat <- "stcn"

g1 <- rbind(a1, b1, c1, d1)

### plotting

ggplot(g1, aes(x=publication_year, y=n, group=language_primary, colour=language_primary)) +
  geom_line(aes(color=language_primary)) +
  scale_x_continuous(breaks = seq(from = 1500, to = 1800, by = 50))+
  facet_wrap(~cat, scales = "free") 