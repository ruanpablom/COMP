delim	[ \t\n]
ws	{delim}+
digito	[0-9]
letra   [a-zA-Z]
char [ -~]
literal \"({char})*\"
num	{digito}+(\.{digito}*(E[+-]?{digito}+)?)?
id ({letra}|\_)({letra}|{digito}|_)*

%%
{ws}	    {}
"+"	    {return TADD;}
"-"	    {return TSUB;}
"*"	    {return TMUL;}
"/"	    {return TDIV;}
"("	    {return TAPAR;}
")"	    {return TFPAR;}
","         {return TVIRG;}
";"         {return TPEV;}
"="         {return TATRIB;}
"&&"        {return TAND;}
"||"        {return TOR;}
"=="        {return TEQUAL;}
"!="        {return TNEQUAL;}
"!"         {return TNOT;}
">="        {return TBIGEQUAL;}
"<="        {return TSMALLEQUAL;}
">"         {return TBIG;}
"<"         {return TSMALL;}
"if"        {return TIF;}
"else"      {return TELSE;}
"while"     {return TWHILE;}
"do"        {return TDO;}
"return"    {return TRETURN;}
"String"    {return TSTRING;}
"int"       {return TINT;}
"void"      {return TVOID;}
"read"      {return TREAD;}
"print"     {return TPRINT;}
"{"         {return TABLOC;}
"}"         {return TFBLOC;}
{num}	    {yylval=atof(yytext); return TNUM;}
{id}        {return TID;}
{literal}   {return TLITERAL;} 
