% 1. Load the Expert System (which automatically loads the patients)
:- consult('diabetes_expert.pl').

% --- CONFUSION MATRIX CALCULATION ---

% True Positive (TP): AI said Diabetic, Patient IS Diabetic
count_tp(Count) :-
    findall(ID, (diagnose(ID, diabetic), patient(ID, _, _, _, _, _, _, _, _, 1)), List),
    length(List, Count).

% True Negative (TN): AI said Healthy, Patient IS Healthy
count_tn(Count) :-
    findall(ID, (diagnose(ID, healthy), patient(ID, _, _, _, _, _, _, _, _, 0)), List),
    length(List, Count).

% False Positive (FP): AI said Diabetic, but Patient is Healthy (False Alarm)
count_fp(Count) :-
    findall(ID, (diagnose(ID, diabetic), patient(ID, _, _, _, _, _, _, _, _, 0)), List),
    length(List, Count).

% False Negative (FN): AI said Healthy, but Patient is Diabetic (Missed Diagnosis)
count_fn(Count) :-
    findall(ID, (diagnose(ID, healthy), patient(ID, _, _, _, _, _, _, _, _, 1)), List),
    length(List, Count).

% --- FINAL REPORT GENERATOR ---

print_report :-
    % 1. Get all the numbers
    count_tp(TP),
    count_tn(TN),
    count_fp(FP),
    count_fn(FN),
    
    % 2. Calculate Totals
    Total is TP + TN + FP + FN,
    Correct is TP + TN,
    Accuracy is (Correct / Total) * 100,
    
    % 3. Calculate Precision (How trustworthy is a 'Diabetic' diagnosis?)
    % Avoid division by zero
    (TP + FP > 0 -> Precision is (TP / (TP + FP)) * 100 ; Precision is 0),

    % 4. Calculate Recall (How many diabetics did we catch?)
    (TP + FN > 0 -> Recall is (TP / (TP + FN)) * 100 ; Recall is 0),

    % 5. Print the Report
    write('=========================================='), nl,
    write('      EXPERT SYSTEM PERFORMANCE REPORT    '), nl,
    write('=========================================='), nl,
    format('Total Patients Scanned: ~w', [Total]), nl, nl,
    
    write('--- Confusion Matrix ---'), nl,
    format('True Positives  (Correctly Sick):    ~w', [TP]), nl,
    format('True Negatives  (Correctly Healthy): ~w', [TN]), nl,
    format('False Positives (False Alarm):       ~w', [FP]), nl,
    format('False Negatives (Missed Diagnosis):  ~w', [FN]), nl, nl,
    
    write('--- Metrics ---'), nl,
    format('ACCURACY:  ~2f %', [Accuracy]), nl,
    format('PRECISION: ~2f %', [Precision]), nl,
    format('RECALL:    ~2f %', [Recall]), nl,
    write('=========================================='), nl.