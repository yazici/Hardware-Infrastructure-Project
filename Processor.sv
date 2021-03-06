module Processor(
	input logic Clk, Reset, 
	output logic [31:0]MemData
);

//fios para ligar os modulos
wire [63:0]Fio_PCin; //liga o alu_out ao PC
wire [63:0]Fio_PCout; //liga PC ao raddres, separar os 32 bits menos significativos, liga PC ao muxa
wire [63:0]Fio_muxAula; // liga o muxa a alu
wire [63:0]Fio_muxBula; // liga o muxb  a alu
wire Fio_PCwrite; // fio que funciona como flag para ver se vamos ter que escrever algo em PC
wire Fio_Wr; //flag que indica que se vamos escrever ou nao na memoria; 0 = nao escreve nada
wire Fio_AluSrcA; // seletor do meu mux A
wire [1:0]Fio_AluSrcB; //seletor do meu mux B
wire [2:0]Fio_Alufunct;
wire [31:0]Fio_Adressin; //liga o alu_out ao PC


//fios fantasmas
wire overflow;
wire negativo;
wire zero;
wire igual;
wire maior;
wire menor;

wire [63:0]Fio_dadoA;
wire [63:0]Fio_dadoB;
wire [63:0]Fio_dadoC;
wire [63:0]Fio_dadoD;

wire [31:0]Fio_fantasma1;
wire [31:0]Fio_fantasma2;

//submodulos
register PC(.clk(Clk), .reset(Reset),.regWrite(Fio_PCwrite), .DadoIn(Fio_PCin), .DadoOut(Fio_PCout), .DadoOut_inst(Fio_Adressin));
Memoria32 MenInst(.raddress(Fio_Adressin), .waddress(Fio_fantasma1), .Clk(Clk), .Datain(Fio_fantasma2), .Dataout(MemData), .Wr(Fio_Wr));
MUXA MuxA(.AluSrcA(Fio_AluSrcA), .dadoA(Fio_PCout), .dadoB(Fio_dadoB), .dadoOUT(Fio_muxAula));
MUXB MuxB(.AluSrcB(Fio_AluSrcB), .dadoA(Fio_dadoA), .dadoB(64'd4), .dadoC(Fio_dadoC), .dadoD(Fio_dadoD), .dadoOUT(Fio_muxBula));
ula64 ALU(Fio_muxAula, Fio_muxBula, Fio_Alufunct, Fio_PCin, overflow, negativo, zero, igual, maior, menor);
ControlUnit Unidade_Controle(.Clk(Clk), .Reset(Reset), .PCwrite(Fio_PCwrite), .AluSrcA(Fio_AluSrcA), .Wr(Fio_Wr), .AluSrcB(Fio_AluSrcB), .ALUFct(Fio_Alufunct));

endmodule
