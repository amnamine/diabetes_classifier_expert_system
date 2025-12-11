% 1. Import the patient data
:- consult('patients.pl').

% --- MEDICAL EVIDENCE RULES ---

% Rule 1: High Glucose (Clear Indicator)
% We raise the bar to 155 to be sure.
has_high_glucose(ID) :-
    patient(ID, _, Glucose, _, _, _, _, _, _, _),
    Glucose > 155.

% Rule 2: The "Metabolic" Profile (Glucose + Obesity)
% This is the most common Type 2 profile.
% We check for Glucose > 125 AND BMI > 30.
has_metabolic_risk(ID) :-
    patient(ID, _, Glucose, _, _, _, BMI, _, _, _),
    Glucose > 125,
    BMI > 30.0.

% Rule 3: Age & Genetic History
% If the patient is older (>35) AND has a very high genetic score (>0.8),
% we diagnose even if glucose is lower (but still > 105).
has_genetic_risk(ID) :-
    patient(ID, _, Glucose, _, _, _, _, Pedigree, Age, _),
    Glucose > 105,
    Age > 35,
    Pedigree > 0.8.

% Rule 4: Pregnancy Risk
% If they have had many pregnancies (>8) and elevated glucose.
has_pregnancy_risk(ID) :-
    patient(ID, Pregnancies, Glucose, _, _, _, _, _, _, _),
    Pregnancies > 8,
    Glucose > 110.

% --- DIAGNOSTIC ENGINE ---

diagnose(ID, diabetic) :- has_high_glucose(ID).
diagnose(ID, diabetic) :- has_metabolic_risk(ID).
diagnose(ID, diabetic) :- has_genetic_risk(ID).
diagnose(ID, diabetic) :- has_pregnancy_risk(ID).

% Default: If none of the strict rules apply, they are Healthy.
diagnose(ID, healthy) :-
    \+ diagnose(ID, diabetic).