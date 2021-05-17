from ortools.sat.python import cp_model
from flask import Flask, jsonify,request
import pandas as pd
import mysql.connector


app = Flask(__name__)

@app.route("/scheduler",methods=['GET'])
def main():
    df = pd.DataFrame(columns=('day','employee','shift'))
    num_nurses =  int(str(request.args['nume']))
    num_shifts = int(str(request.args['nums']))
    num_days = int(str(request.args['numd']))
    all_nurses = range(num_nurses)
    all_shifts = range(num_shifts)
    all_days = range(num_days)

    model = cp_model.CpModel()

    shifts = {}
    for n in all_nurses:
        for d in all_days:
            for s in all_shifts:
                shifts[(n, d,
                        s)] = model.NewBoolVar('shift_n%id%is%i' % (n, d, s))

    for d in all_days:
        for s in all_shifts:
            model.Add(sum(shifts[(n, d, s)] for n in all_nurses) == 1)

    # Each nurse works at most one shift per day.
    for n in all_nurses:
        for d in all_days:
            model.Add(sum(shifts[(n, d, s)] for s in all_shifts) <= 1)

    min_shifts_per_nurse = (num_shifts * num_days) // num_nurses
    if num_shifts * num_days % num_nurses == 0:
        max_shifts_per_nurse = min_shifts_per_nurse
    else:
        max_shifts_per_nurse = min_shifts_per_nurse + 1
    for n in all_nurses:
        num_shifts_worked = 0
        for d in all_days:
            for s in all_shifts:
                num_shifts_worked += shifts[(n, d, s)]
        model.Add(min_shifts_per_nurse <= num_shifts_worked)
        model.Add(num_shifts_worked <= max_shifts_per_nurse)

    solver = cp_model.CpSolver()
    solver.Solve(model)
    for d in all_days:
        for n in all_nurses:
            for s in all_shifts:
                if solver.Value(shifts[(n, d, s)]) == 1:
                    df = df.append({"day":d,"employee": n,"shift": s}, ignore_index=True)

    return df.to_json(orient="records")

@app.route("/register",methods=['GET'])
def register():
    username = str(request.args['username'])
    password = str(request.args['password'])
    name = str(request.args['name'])
    df = {}
    mydb = mysql.connector.connect(host="localhost", user="root", passwd="iamhacker", database="pythonassignment")
    mycur = mydb.cursor()
    mycur.execute ("INSERT INTO logindata (username, password, name) VALUES (%s,%s,%s)",(username,password,name))
    mydb.commit()
    df['login'] = 'True'
    mydb.close()
    return jsonify(df)

@app.route("/login",methods=['GET'])
def login():
    username = str(request.args['username'])
    password = str(request.args['password'])
    mydb = mysql.connector.connect(host="localhost", user="root", passwd="iamhacker", database="pythonassignment")
    mycur = mydb.cursor()
    df={}
    query = "SELECT username,password,name FROM logindata WHERE username='"+username+"' AND password = '"+password+"' "
    mycur.execute(query)
    account = mycur.fetchone()
    if account:
        df['login'] = 'True'
        df['name'] = str(account[2])
        mydb.close()
        return jsonify(df)
    else:
        df['login'] = 'False'
        mydb.close()
        return jsonify(df)

if __name__ == '__main__':
    app.run(debug=True)