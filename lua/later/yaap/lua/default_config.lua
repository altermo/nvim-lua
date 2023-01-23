return {
    {'[',']'},
    {'(',')'},
    {'{','}'},
    {'"','"'},
    {"'","'"},
    {'`','`'},
    ft={
        markdown={
            {'```','```'},
            {'<!--','-->'},
        },
        css={{'<!--','-->'}},
        c={{'/*','*/'}},
        cpp={{'/*','*/'}},
        cs={{'/*','*/'}},
        go={{'/*','*/'}},
        java={{'/*','*/'}},
        javascript={{'/*','*/'}},
        jsonc={{'/*','*/'}},
        lua={{'[[',']]'}},
        rust={{'/*','*/'}},
        typescript={{'/*','*/'}},
        python={
            {'"""','"""'},
            {"'''","'''"},
        },
    },
}
