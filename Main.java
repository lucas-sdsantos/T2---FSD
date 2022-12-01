public class Main {

    public static void main (String args[]){
        int [] v = new int [5];
        v[0] = 8;
        v[1] = 1;
        v[2]=1;
        v[3]= 44;
        v[4]= 100;
        System.out.println (getMedia(v));
        System.out.println(getMediana(v));
        System.out.println (getModa(v));

    }
    
    public static double getMedia (int [] v){
        double soma = 0.0;
        double media = 0.0;
        int count = 0;
        
        for (int i = 0; i<v.length; i++){
            if (v[i]!= 0){
            soma = soma + v[i];
            count++;
            }
        }
        media = soma/count;
        return media;
        
    }

    public static double getMediana (int [] v){
        double mediana = 0.0;
        if (v.length%2==0){
            mediana = v[(v.length/2)] + v[(v.length/2)+1];
            return mediana;
        }
        else{
             
            mediana = v[(v.length/2)];
            return mediana;
        }
    }

    public static int getModa (int [] v){
        int moda = 0;
        int maxCount = 0;
        for (int i = 0; i < v.length; i++){
            int count =0;
            for (int j=0; j < v.length; j++){
                if (v[j]==v[i]){
                    count ++;
                }

            }
            if (count > maxCount){
                maxCount = count;
                moda = v[i];
            }
        }
        return moda;
    }
}

