import qbs
Project
{
   
    name: "RECALC"
     
    
            Product
    {   
        name: "FPGA"
        type: "obj"

       
        Group
        {
            name: "vhd"
            files: ["*.vhd"]
            fileTags: ['vhd']
            excludeFiles: ["*_tb.vhd"]
        }
        
        Group
        {
            name: "tb_vhd"
            files: ["*_tb.vhd"]
            fileTags: ['tb_vhd']
        }

        
        
        //ghdl  -a  --ieee=synopsys -fexplicit -C %f
        Rule
               {
                   //multiplex: true
                   inputs: ['tb_vhd']
                   
                   Artifact
                   {
                       fileTags: ['obj']
                       //filePath: input.fileName + '.o'
                   }
                   prepare:
                   {
                   var args = [];
                   //Keys:
                       args.push("-a")
                       args.push("--ieee=synopsys")
                       args.push("-fexplicit")
                       args.push("-C")
                       args.push(input.filePath);
                      
                   var ghdlPath = "ghdl"
                   var cmd = new Command(ghdlPath, args);
                   cmd.description = 'compiling ' + input.fileName;
                   cmd.highlight = 'compiler';
                   cmd.silent = false;
                   return cmd;
                   }
               }
        
        
        
        
        
        
        
         
    }  
    
  
    
}
