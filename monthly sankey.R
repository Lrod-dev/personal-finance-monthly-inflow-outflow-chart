#the goal of this Sankey diagram is to visualize outflows from my account on a monhtly basis
#this app is only as verbose as your input, which is kind of taxing for manual input


#install.packages("networkD3")
#library(networkD3)

#income_data <- read.csv("income_data.csv")
#expense_data <- read.csv("expense_data.csv")

# Example income data for the month
income_data <- data.frame(
  source = c("Paycheck 1", "Paycheck 2"),
  date = as.Date(c("2024-09-11", "2024-09-25")),
  amount = c(2759.82, 2621.29)  # Amount in dollars
)

# Example expense data for the month
expense_data <- data.frame(
  category = c("Housing", "Vehicle", "Groceries", "Phone", "Internet", "Gas", "Electricity", 
               "Water", "Subscriptions", "Entertainment", "Savings"),
  amount = c(50, 182, 300, 106.08, 118.64, 51.51, 193.08, 110, 83.60, 200, 500)  # Amount in dollars
)

# Summarize total income
total_income <- sum(income_data$amount)

# Summarize total outflows
total_outflows <- sum(expense_data$amount)

# Check if total inflows match total outflows (savings or debt could fill the gap)
remaining <- total_income - total_outflows
print(remaining)  # This tells you if there's leftover or deficit

flow_data <- data.frame(
  source = c("Income", "Income",                # Layer 1
             "Essentials", "Essentials", "Essentials",    # Layer 2
             "Discretionary", "Discretionary",             # Layer 2
             "Bills", "Bills",                 # Layer 3 under Essentials
             "Leisure", "Investments"),        # Layer 3 under Discretionary
  target = c("Essentials", "Discretionary",     # Layer 1
             "Bills", "Food", "Transport",      # Layer 2 under Essentials
             "Leisure", "Investments",          # Layer 2 under Discretionary
             "Housing", "Utilities",            # Layer 3 under Bills
             "Entertainment", "Savings"),       # Layer 3 under Discretionary
  amount = c(1000, 500,                         # Layer 1
             700, 200, 100,                     # Layer 2 under Essentials
             300, 200,                          # Layer 2 under Discretionary
             500, 200,                          # Layer 3 under Bills
             150, 100)                          # Layer 3 under Discretionary
)

# Update nodes for more layers
nodes <- data.frame(name = unique(c(flow_data$source, flow_data$target)))

# Map source and target to node indices
flow_data$source_id <- match(flow_data$source, nodes$name) - 1
flow_data$target_id <- match(flow_data$target, nodes$name) - 1

# Create the multi-layer Sankey diagram
sankey_dynamic <- sankeyNetwork(
  Links = flow_data, 
  Nodes = nodes,
  Source = "source_id", 
  Target = "target_id",
  Value = "amount", 
  NodeID = "name",
  sinksRight = FALSE,   # Flow from left to right
  fontSize = 12,        # Adjust the font size
  nodeWidth = 40,       # Width of nodes
  nodePadding = 20,     # Padding between nodes
  width = 1000,         # Overall width of the diagram
  height = 800          # Overall height of the diagram
)

# Display the Sankey diagram
sankey_dynamic

# Save the Sankey diagram to an HTML file
saveNetwork(sankey_dynamic, file = "sankey_dynamic_diagram.html")

# Open the saved HTML file in your default browser
browseURL("sankey_dynamic_diagram.html")

# Read income and expense data from CSV
#income_data <- read.csv("income_data.csv")
#expense_data <- read.csv("expense_data.csv")