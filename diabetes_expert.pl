% 1. Import the patient data
:- consult('patients.pl').

% --- MEDICAL RULES (The "Rule Base") ---

% Rule 1: High Glucose (The strongest indicator)
% Medicine says: Fasting glucose > 126 is distinct diabetes.
has_high_glucose(ID) :-
    patient(ID, _, Glucose, _, _, _, _, _, _, _),
    Glucose > 126.

% Rule 2: Obesity
% Medicine says: BMI > 30 is obese.
is_obese(ID) :-
    patient(ID, _, _, _, _, _, BMI, _, _, _),
    BMI > 30.

% Rule 3: Hypertension (High Blood Pressure)
has_high_bp(ID) :-
    patient(ID, _, _, BP, _, _, _, _, _, _),
    BP > 80.

% --- DIAGNOSTIC ENGINE ---

% Diagnosis Rule 1: Certain Diabetes
% IF Glucose is very high, we diagnose diabetes immediately.
diagnose(ID, diabetic) :-
    has_high_glucose(ID).

% Diagnosis Rule 2: Risk-Based Diagnosis
% IF Glucose is borderline (between 100 and 125) AND Patient is Obese, we diagnose diabetes.
diagnose(ID, diabetic) :-
    patient(ID, _, Glucose, _, _, _, _, _, _, _),
    Glucose > 100, 
    Glucose =< 126,
    is_obese(ID).

% Default Rule: Else, they are healthy (negation as failure)
diagnose(ID, healthy) :-
    \+ diagnose(ID, diabetic).

% --- VALIDATION (Checking our accuracy) ---

% Rule to check if our diagnosis matches the actual CSV data
% We are right IF (Diagnosis is diabetic AND Actual is 1) OR (Diagnosis is healthy AND Actual is 0).
correct_diagnosis(ID) :-
    diagnose(ID, diabetic),
    patient(ID, _, _, _, _, _, _, _, _, 1). % 1 means diabetic in CSV

correct_diagnosis(ID) :-
    diagnose(ID, healthy),
    patient(ID, _, _, _, _, _, _, _, _, 0). % 0 means healthy in CSV