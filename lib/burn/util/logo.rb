module Burn
  module Util
    class Logo
      def initialize(version)
        @version = version
      end
      
      def to_s
        # used a icon from noun project. Thanks Jenny!
        # http://thenounproject.com/term/fire/24187/
        <<-EOS
                                                                
             `.::-`                                             
             :hNMMNNds/.                                        
               :dMMMMMMNdo.                                     
                `oNMMMMMMMNh:                                   
                  /NMMMMMMMMNy.                                 
                   +MMMMMMMMMMm/                                
                    dMMMMMMMMMMNo                               
                    oMMMMMMMMMMMM+                              
                    +MMMMMMMMMMMMN/                             
                    sMMMMMMMMMMMMMm.                            
                   `mMMMMMMMMMMMMMMs        ::`                 
                   /MMMMMMMMMMMMMMMN.       `hh/`               
                  `dMMMMMMMMMMMMMMMMo        -NMd/`             
                  sMMMMMMMMMMMMMMMMMd         yMMMh-            
                 /MMMMMMMMMMMMMMMMMMN.        /MMMMN+           
                :NMMMMMMMMMMMMMMMMMMM-        :MMMMMMo`         
               -mMMMMMMMMMMMMMMMMMMMM/        oMMMMMMMo         
              .dMMMMMMMMMMMMMMMMMMMMMo       .mMMMMMMMN:        
             .dMMMMMMMMMMMMMMMMMMMMMMm`     .dMMMMMMMMMm`       
            `dMMMMMMMMMMMMMMMMMMMMMMMMy.```/mMMMMMMMMMMMo       
           `hMMMMMMMMMMMMMMMNNNMMMMMMMMNhhmMMMMMMMMMMMMMm`      
          `hMMMMMMMMMMMMMMMN/`-/yNMMMMMMMMMMMMMMMMMMMMMMM:      
         `yMMMMMMMMMMMMMMMMMN-   .hMMMMMMMMMMMMMMMMMMMMMMy      
         sMMMMMMMMMMMMMMMMMMMy     sMMMMMMMMMMMMMMMMMMMMMd      
        +MMMMMMMMMMMMMMMMMMMMd     `hMMMMMMMMMMMMMMMMMMMMN`     
       -NMMMMMMMMMMMMMMMMMMMMs      .NMMMMMMMMMMMMMMMMMMMM-     
      `dMMMMMMMMMMMMMMMMMMMMm.       sMMMMMMMMMMMMMMMMMMMM:     
      +MMMMMMMMMMMMMMMMMMMMN-        -MMMMMMMMMMMMMMMMMMMM.     
     `mMMMMMMMMMMMMMMMMMMMm-          NMMMN+NMMMMMMMMMMMMN      
     /MMMMMMMMMMMMMMMMMMMh.           NMMMM--mMMMMMMMMMMMh      
     yMMMMMMMMMMMMMMMMMN+`           .MMMMM+ -mMMMMMMMMMM+      
    `mMMMMMMMMMMMMMMMMh-             +MMMMM:  /MMMMMMMMMN.      
    -MMMMMMMMMMMMMMMN+`              yMMMMs    hMMMMMMMMy       
    :MMMMMMMMMMMMMMd-                :hhy:`    /MMMMMMMN.       
    .NMMMMMMMMMMMMy.                  ``       -MMMMMMMo        
     dMMMMMMMMMMMs`                            .MMMMMMd`        
     +MMMMMMMMMMy`                             :MMMMMN-         
     `dMMMMMMMMN.                              sMMMMN/          
      :NMMMMMMMh                              `mMMMN+           
       +MMMMMMMs            burn              oMMMN+            
        +NMMMMMh                             -NMMm:             
         /mMMMMN-          v#{@version}           .dMNy.              
          .hNMMMh`                         .dNh:                
           `/mMMMh.                       -hy:`                 
             `+mMMm/`                   `:+.                    
               `/hNMd+.                 ``                      
                  .+hNNy/.                                      
                     `-/oo:                                     
                                                                
                                                                
EOS
      end
      
    end
  end
end
