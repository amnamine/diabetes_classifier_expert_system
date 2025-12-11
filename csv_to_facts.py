import pandas as pd

# Load the dataset
df = pd.read_csv("diabetes.csv")

# Open a new file to write the Prolog facts
with open("patients.pl", "w") as f:
    f.write("% --- PATIENT KNOWLEDGE BASE ---\n")
    f.write("% Format: patient(Id, Preg, Glucose, BP, Skin, Insulin, BMI, Pedigree, Age, ActualOutcome).\n\n")
    
    # Loop through every row in the CSV
    for index, row in df.iterrows():
        # Create a unique ID for each patient (e.g., p0, p1, p2...)
        patient_id = f"p{index}"
        
        # Write the fact
        # We cast values to int/float to ensure they are clean numbers
        fact = "patient({}, {}, {}, {}, {}, {}, {}, {}, {}, {}).\n".format(
            patient_id, 
            int(row['Pregnancies']), 
            int(row['Glucose']), 
            int(row['BloodPressure']), 
            int(row['SkinThickness']), 
            int(row['Insulin']), 
            float(row['BMI']), 
            float(row['DiabetesPedigreeFunction']), 
            int(row['Age']), 
            int(row['Outcome'])
        )
        f.write(fact)

print("Success! Created 'patients.pl' with all patient data.")