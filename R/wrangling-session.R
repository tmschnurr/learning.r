source(here::here("R/package-loading.R"))


# NHANES-DataManagement ---------------------------------------------------
glimpse(NHANES) #to get a fist quick look at the data-frame
NHANES <- NHANES #easier if you save the dataset as object
View(NHANES) #capital "V" to get table output


# exercise ----------------------------------------------------------------
# get familiar with dataframe
colnames(NHANES)
# Look at contents
str(NHANES)
glimpse(NHANES)
# See summary
summary(NHANES)
# Look over the dataset documentation
?NHANES


# tidy-messy-data ---------------------------------------------------------
table1 #wide format, tidy
table2 #long format, tidy
table3 #messy, rate = character table (not a numerican or integer table), cannot do any computations with it
table4a #messy, 2 columns, doesnt tell us what these numbers are about
table4b #messy, numbers but we dont know what it is about

#tidy up from the beginning, you will have less work later!


# pipe-operator -----------------------------------------------------------
# %>% ctrol + shift + m
# helps to make code more readable
colnames(NHANES)
NHANES %>% colnames #gives you the same as above (names of the columns)

# Standard R way of "chaining" functions together
glimpse(head(NHANES))
NHANES %>%
  head() %>%
  glimpse()


# mutate() transforming or adding variables ---------------------------------------------------------
# Modify an existing variable
NHANES %>%
  mutate(Height = Height / 100)

# Or create a new variable based on a condition
NHANES %>%
  mutate(HighlyActive = if_else(PhysActiveDays >= 5, "yes", "no"))

# Create or replace multiple variables by using the ","
NHANES %>%
  mutate(new_column = "only one value",
         Height = Height / 100)

NHANES_update <- NHANES %>%
  mutate(UrineVolAverage = (UrineVol1 + UrineVol2) / 2)

# exercise2 ---------------------------------------------------------------
# Check the names of the variables
colnames(NHANES)
summary(NHANES$Pulse)
summary(NHANES$Age)
# Pipe the data into mutate function and:
NHANES_modified <- NHANES %>% # dataset
  mutate(
    # 1. Calculate average urine volume
    UrineVolAverage = (UrineVol1 + UrineVol2) /2,
    # 2. Modify Pulse variable
    PulseSec = Pulse/60,
    # 3. Create YoungChild variable using a condition
    YoungChild = if_else(Age < 6, TRUE, FALSE)
  )
NHANES_modified
table(NHANES_modified$YoungChild)
View(NHANES_modified)


# select() specific data by the variables ----------------------------------------------------------
# to select specific columns/variables by name, without quotes
# of course this smaller dataset can be saved as a new data.frame
NHANES_characteristics <- NHANES %>%
  select(Age, Gender, BMI)
str(NHANES_characteristics)
summary(NHANES_characteristics)
# you can also deselect a variable (-)
NHANES %>%
  select(-HeadCirc)

# matching() -------------------------------------------------------
#for example select all variables with "Vol"
NHANES_BP_Vol <- NHANES_modified %>%
  select(starts_with("BP"), contains("Vol"))
summary(NHANES_BP_Vol)

?select #get information on options to "select" by
?select_helpers
# one option is also to use regular expressions for matches()


# rename() specific columns---------------------------------------------------------
# rename using the formula: newname = oldname
NHANES %>%
  rename(NumberBabies = nBabies) #we can do several at once


# filter()/subsetting the data by row----------------------------------------------------------------
# select only female participants, aka making a subset
NHANES %>%
  filter(Gender == "female")

#can also go the other way round
NHANES %>%
  filter(Gender != "male") #now keep everything that is not male == all are female

#can also be used on numeric variables
NHANES %>%
  filter(BMI ==25) #now we have only 35 participants left in dataset
#where BMI >=25
NHANES %>%
  filter(BMI >=25) #now we have 5,412 individuals with BMI greater or equal to 25

#several variables, when BMI is 25 and gender is female
NHANES %>%
  filter(BMI == 25 & Gender == "female")

#when BMI is 25 or gender = female
NHANES %>%
  filter(BMI == 25 | Gender == "female")


# arrange() sorting/(re)arraning your data by column---------------------------------------------------------------
# default setting = will arrange with ascending order (smalles on top and bigger down)
NHANES %>%
  arrange(Age) %>%
  select(Age) #say select only Age so you can easily check it directly

#order descending, use desc() option
NHANES %>%
  arrange(desc(Age)) %>%
  select(Age)

#order by age and gender
#character variable will be ordered by alphabet
NHANES %>%
  arrange(Age, desc(Gender)) %>%
  select(Age, Gender)


# exercise3 ---------------------------------------------------------------
# To see values of categorical data
summary(NHANES)

# 1. BMI between 20 and 40 and who have diabetes
NHANES %>%
  # format: variable >= number
  filter(BMI >= 20 & BMI <= 40 & Diabetes == "Yes")

# 2. Working or renting, and not diabetes
NHANES %>%
  filter(HomeOwn == "Own" | HomeOwn == "Rent" & Diabetes == "No") %>%
  select(HomeOwn, BMI, Diabetes)

# 3. How old is person with most number of children.
NHANES %>%
  arrange(desc(nBabies)) %>%
  select(Age, nBabies)


# group_by(), summarise() create summary of the data, alone or by a group(s)-------------------------------------------------
# group_by on its down does nothing, need to be combined with another function

#summarise() by itself
NHANES %>%
  summarise(MaxAge = max(Age, na.rm = T), #need to remove NA so it can calculate mean-max
            MeanBMI = mean(BMI, na.rm=T))

# combine with group_by()
NHANES %>%
  group_by(Gender) %>%
  summarise(MaxAge = max(Age, na.rm = T),
            MeanBMI = mean(BMI, na.rm = T))

# group by gender and diabetes
NHANES %>%
  group_by(Gender, Diabetes) %>%
  summarise(MaxAge = mean(Age, na.rm = T),
            MeanBMI = mean(BMI, na.rm = T))


# gather() convert wide to long----------------------------------------------------------------
# can be used to transform from wide to long
# long data is usually also more tidy compared to wide form
# for specific type of analysis, long format is better to use! (example: linear mixed models)

#Original data
table4b
# change to long data-format
# Convert to long form by stacking population by each year
# Use minue to exclude a variable (country) from being "gathered"
table4b %>%
  gather(year, population, -country)

# for large datasets, keep only variables of interest
nhanes_chars <- NHANES %>%
  select(SurveyYr, Gender, Age, Weight, Height, BMI, BPSysAve)
nhanes_chars

# Convert to long form, excluding year and gender
nhanes_long <- nhanes_chars %>%
  gather(Measure, Value, -SurveyYr, -Gender)
nhanes_long

# Calculate mean on each measure, by gender and year
nhanes_long %>%
  group_by(SurveyYr, Gender, Measure) %>%
  summarise(MeanValue = mean(Value, na.rm = TRUE),
            standDev = sd(Value, na.rm = TRUE),
            Min = min(Value, na.rm=TRUE),
            Max = max(Value, na.rm = TRUE))

# spread() convert long to wide ----------------------------------------------------------------
# convert from long to wide
table2
table2 %>%
  spread(key = type, value = count)
#The key is the discrete value that will make up the new column names,
#while the value will be column that will make up the values of the new columns.


# exercise4 ---------------------------------------------------------------
# select data from NHANES set
nhanes_exercise <- NHANES %>%
  select(Gender, Age, DiabetesAge, BMI, starts_with("BP"), AlcoholDay, PhysActiveDays, nBabies, Poverty, TotChol)

         #solution is also on the website:
         #first mutate so that only PA more than five days, then %>%
         #select() only the variables we need %>%
          # rename() variables as we were asked to
         #filter() by age

        # then:
         #  gather() and group by(), summarise(), arrange(), spread()


