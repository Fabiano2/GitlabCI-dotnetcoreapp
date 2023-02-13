pipeline {

    agent any

    environment {
        BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].userId}"
        url_job = "${JOB_URL}"
        target_ip = '172.16.32.31'
        workDir = "/tmp/workdir/"
        emails_lideres = "null"
        saida = "null"
        comparar = "null"
    }


    stages{
        stage('Validar parametros'){
            steps{
                script{
                    if (usuario == "" ){
                        sh '''
                            erro="<BR>ERRO: Login não Fornecido!"
                            echo "$erro"
                            emailerro='<div style="width: 80%;display: flex; flex-direction: row;flex-wrap: wrap;justify-content: center;align-items: center;font-family: Arial; color: gray; background-color: white">	<div style=" width: 100%;height: 20%;margin: 10px;">		<div style = "width: 80%;height: auto;position: relative; padding: 10px;margin: 0 auto; border-bottom: 1px solid black">				<h1 style= "text-align:center; width:40%;margin: 0 auto";>Falha ao desbloquear usuário!</h1>		</div>			</div>	<div style="height: 100%; width:100%; margin: 0 auto;">		<p style = "margin:0 auto;width: 60%">Houve uma tentativa de desbloqueio do usuario '${usuario}' através do <a href = "'${url_job}'">Job do Jenkins</a>, mas houve uma <span style="color:red;font-weight:bold">FALHA</span>, acesse o output do job para mais detalhes.<br><span style="color:red;font-weight:bold">'$erro'</span>		</p>			</div></div>'
                            echo "$emailerro" > ./emailerro.html
                            exit 1
                        '''
                    }
                }
            }
        }

        stage('Desbloquear usuario'){
            steps{
                script{
                    sh '''
                    echo "" > ./email.html
                    #echo "" > /root/exit.txt
                    erro="<BR>ERRO: Usuário já desbloqueado!"
                    echo "$erro"
                    emailerro='<div style="width: 80%;display: flex; flex-direction: row;flex-wrap: wrap;justify-content: center;align-items: center;font-family: Arial; color: gray; background-color: white">	<div style=" width: 100%;height: 20%;margin: 10px;">		<div style = "width: 80%;height: auto;position: relative; padding: 10px;margin: 0 auto; border-bottom: 1px solid black">				<h1 style= "text-align:center; width:40%;margin: 0 auto";>Falha ao desbloquear usuário!</h1>		</div>			</div>	<div style="height: 100%; width:100%; margin: 0 auto;">		<p style = "margin:0 auto;width: 60%">Houve uma tentativa de desbloqueio do usuario '${usuario}' através do <a href = "'${url_job}'">Job do Jenkins</a>, mas houve uma <span style="color:red;font-weight:bold">FALHA</span>, acesse o output do job para mais detalhes.<br><span style="color:red;font-weight:bold">'$erro'</span>		</p>			</div></div>'
                    echo "$emailerro" > ./emailerro.html
                    '''

                    sh """
                    ssh -tt root@${target_ip} '
                        
                        hostname
                        if [ ! -d "${workDir}" ]; then
                                mkdir "${workDir}"
                                echo "Diretorio ${workDir} Criado"
                        else
                                rm -r ${workDir}/*

                        fi
                    '
                    """

                    sh """
                    ls
                    scp ./*.sh root@${target_ip}:${workDir}

                    """

                    sh """
                    ssh -tt root@${target_ip} '
                        ls ${workdir}
                        chmod 777 -R ${workdir}
                        ${workdir}/desbloquear.sh ${usuario}
                        ${workdir}/get_lider.sh ${usuario}
                    '
                    """
                    sh """
                        scp root@${target_ip}:/root/*.txt .
                        chmod 777 ./*.txt
                    """
                    def get_lideres = readFile(file: './emails_lideres.txt')
                    def saida = readFile(file: './exit.txt')
                    println ">>>>>>>Saida:"
                    println saida.getClass();
                    def comparar = readFile(file: './comparar.txt')
                    println ">>>>>>>comparar:"
                    println comparar.getClass();
                    

                    if (saida.equals(comparar)){
                        echo "entrou no if!!!";
                        sh 'exit 1';
                    }

                    emails_lideres = get_lideres
                    echo emails_lideres
                    echo "Saida = " + saida
                    echo ""
                    
                    sh '''
                    erro="<BR>ERRO: Usuário não encontrado!"
                    echo "$erro"
                    emailerro='<div style="width: 80%;display: flex; flex-direction: row;flex-wrap: wrap;justify-content: center;align-items: center;font-family: Arial; color: gray; background-color: white">	<div style=" width: 100%;height: 20%;margin: 10px;">		<div style = "width: 80%;height: auto;position: relative; padding: 10px;margin: 0 auto; border-bottom: 1px solid black">				<h1 style= "text-align:center; width:40%;margin: 0 auto";>Falha ao desbloquear usuário!</h1>		</div>			</div>	<div style="height: 100%; width:100%; margin: 0 auto;">		<p style = "margin:0 auto;width: 60%">Houve uma tentativa de desbloqueio do usuario '${usuario}' através do <a href = "'${url_job}'">Job do Jenkins</a>, mas houve uma <span style="color:red;font-weight:bold">FALHA</span>, acesse o output do job para mais detalhes.<br><span style="color:red;font-weight:bold">'$erro'</span>		</p>			</div></div>'
                    echo "$emailerro" > ./emailerro.html
                    '''

                    sh """
                    ssh -tt root@${target_ip} '
                        ${workdir}/validadesbloq.sh ${usuario}
                    '
                    """                   
                    sh """
                        echo '<div style="width: 80%;display: flex; flex-direction: row;flex-wrap: wrap;justify-content: center;align-items: center;font-family: Arial; color: gray; background-color: white">   <div style=" width: 100%;height: 20%;margin: 10px;">      <div style = "width: 80%;height: auto;position: relative; padding: 10px;margin: 0 auto; border-bottom: 1px solid black">         <h1 style= "text-align:center; width:40%;margin: 0 auto";>Desbloqueio realizado com sucesso!</h1>      </div>   </div>   <div style="height: 100%; width:100%; margin: 0 auto;">      <p style = "margin:0 auto;width: 60%">Você está recebendo esse e-mail porque o usuário '${usuario}' foi desbloqueado no Redmine através do <a href = "'${url_job}'">job do Jenkins</a>.</p>      <table style = "margin: 0 auto; color:black; border: 3px solid white; margin-top:5px;">         <tr>            <td><b>Responsável pelo desbloqueio: </b> </td>            <td> '${BUILD_TRIGGER_BY}'</td>         </tr>         <tr>            <td><b>Usuário desbloqueado: </b></td>            <td>'${usuario}'</td>         </tr>      </table>   </div></div>' > email.html
                    """          
                }
            }
        }
    }




    post{
        success{
            emailext body: '${FILE,path="./email.html"}',
            //emailext body: "${emails_lideres}",
            mimeType: 'text/html',
            subject: 'Desbloqueio realizado com sucesso!',
            //subject: 'DESCONSIDERAR - E-mail de teste',
            //to: "${BUILD_TRIGGER_BY};${emails_lideres};devops@7comm.com.br"
            to: "${BUILD_TRIGGER_BY};"
        }
        unsuccessful {
            emailext body: '${FILE,path="./emailerro.html"}',
            mimeType: 'text/html',
            subject: 'Erro ao desbloquear usuario',
            to: "${BUILD_TRIGGER_BY};"
            //to: "${BUILD_TRIGGER_BY};devops@7comm.com.br;"

        }
    }
}
