/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xaxidma.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xscugic.h"
//#include "xbasic_types.h"
#include "xil_io.h"
#include "xil_types.h"
#include "sine.h"

#define DMA_BASE_ADDR       0x40400000
#define MEM_BASE_ADDR		0x00100000
#define DAC_BASE_ADDR		(MEM_BASE_ADDR + 0x00100000)

#define DMA_MM2S_IRQID   61

XScuGic 	     Intc_ins;
XScuGic_Config   Intc_cfg;
XAxiDma 		 DMA_ins;
XAxiDma_Config   DMA_cfg;

static volatile u32 DMA_MM2S_Flag=0;

void MM2S_ISR(void *CallbackRef);
void print_DDR_cell_u8(u8 *data,u16 size);




int main()
{
    init_platform();

    print("Hello World\n\r");

    XScuGic          *Intc_ins_p = &Intc_ins;
    XScuGic_Config   *Intc_cfg_p = &Intc_cfg;
    Intc_cfg_p = XScuGic_LookupConfig(0);
	XScuGic_CfgInitialize(Intc_ins_p, Intc_cfg_p,Intc_cfg_p->CpuBaseAddress);


	XAxiDma  		*AxiDMA_ins_p = &DMA_ins;
	XAxiDma_Config  *AxiDMA_cfg_p = &DMA_cfg;
    AxiDMA_cfg_p = XAxiDma_LookupConfig(0);
    XAxiDma_CfgInitialize(AxiDMA_ins_p,AxiDMA_cfg_p);


	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
				(Xil_ExceptionHandler)XScuGic_InterruptHandler,
				Intc_ins_p);
	XScuGic_Connect(Intc_ins_p, DMA_MM2S_IRQID,
			    (Xil_ExceptionHandler)MM2S_ISR,
				(void *)&DMA_ins);
//	XScuGic_Connect(Intc_ins_p, DMA_S2MM__IRQID,
//				 (Xil_ExceptionHandler)S2MM_ISR,
//				 (void *)&DMA_ins);
	XScuGic_Enable(Intc_ins_p,DMA_MM2S_IRQID);
	//XScuGic_Enable(Intc_ins_p,DMA_S2MM__IRQID);
	Xil_ExceptionEnable();

	int Index;
	u8 Value=0;
	u8 *TxBufferPtr;

	TxBufferPtr = (u8 *)DAC_BASE_ADDR ;

//	for(Index = 0; Index < 256; Index ++) {
//			xil_printf("%d",Value);
//			TxBufferPtr[Index] = Value;
//			Value = (Value + 1) & 0xFF;
//	}

	int p;
	for(p=0;p<100;p++)
	{
		xil_printf("%d\n",S11[p]);
		TxBufferPtr[p] = S11[p];
	}

	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, 100);
	//Xil_DCacheFlushRange((UINTPTR)RxPacket, 256);

	//print_DDR_cell_u8((u8 *)DAC_BASE_ADDR ,256);

	DMA_MM2S_Flag=0;
//
//	Xuint32 S2MM_DMACR = 0;
//	Xuint32 S2MM_DMASR = 0;

	u32 MM2S_DMACR = 0;
	u32 MM2S_DMASR = 0;

	u32 MM2S_DMASR_temp=0;
	//RESET DMA IP
	Xil_Out32(DMA_BASE_ADDR+0,0x00000004);
	MM2S_DMACR =  (Xil_In32(DMA_BASE_ADDR+0));
	if(MM2S_DMACR & 0x00000004);


	//Run
	MM2S_DMASR =  (Xil_In32(DMA_BASE_ADDR+4));
	MM2S_DMACR =  (Xil_In32(DMA_BASE_ADDR+0));
	Xil_Out32(DMA_BASE_ADDR+0,MM2S_DMACR|0x00000001);
	MM2S_DMASR =  (Xil_In32(DMA_BASE_ADDR+4));

	//IRQ
	MM2S_DMACR =  (Xil_In32(DMA_BASE_ADDR+0));
	Xil_Out32(DMA_BASE_ADDR+0,MM2S_DMACR|0x00005000);

	//ADDR
	Xil_Out32(DMA_BASE_ADDR+24,DAC_BASE_ADDR);

	MM2S_DMASR =  (Xil_In32(DMA_BASE_ADDR+4));
	MM2S_DMACR =  (Xil_In32(DMA_BASE_ADDR+0));

	Xil_Out32(DMA_BASE_ADDR+40,0x00000064);



//	int ii;
//	for(ii=0;ii<4;ii++)
//	{
//
//
//		//LEN
//		Xil_Out32(DMA_BASE_ADDR+40,256);
//
////	    MM2S_DMASR_temp =  (Xil_In32(DMA_BASE_ADDR+4));
////		Xil_Out32(DMA_BASE_ADDR+4,MM2S_DMASR_temp|0x00005000);
//
////		while(((Xil_In32(DMA_BASE_ADDR+4)) & 0x00000002)>>1);
//
//		Value++;
//		for(Index = 0; Index < 256; Index ++) {
//				TxBufferPtr[Index] = Value;
//				Value = (Value + 1) & 0xFF;
//		}
//
//		//write back the data from cache to memory
//		Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, 256);
//
//
//	}


    cleanup_platform();
    return 0;
}


void MM2S_ISR(void *CallbackRef)
{
	DMA_MM2S_Flag=1;
	u32 MM2S_DMASR_temp =  (Xil_In32(DMA_BASE_ADDR+4));
	Xil_Out32(DMA_BASE_ADDR+4,MM2S_DMASR_temp&0x00005000);
	xil_printf("done IRQ");
}

void print_DDR_cell_u8(u8 *data,u16 size)
{
	int i;
    for(i=0;i<size;i++)
    {
    	xil_printf("%d:%d\r\n",i,data[i]);
    }
}

