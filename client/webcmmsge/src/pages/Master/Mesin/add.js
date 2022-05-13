import React, { useState } from 'react';

/// import react router dom
import { useNavigate } from "react-router-dom";

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// combobox react for load data mesin
import AsyncSelect from 'react-select/async'

/// import axios
import axios from "../../../utils/server";
import swal from 'sweetalert'

const AddMesin = () => {
    /// define form state
    const [nomesin, setNomesin] = useState("");
    const [keterangan, setKeterangan] = useState("");
    const [idSite, setIdSite] = useState('')
    /// form validate
    const [validation, setValidation] = useState([]);
    /// previous page handler
    const history = useNavigate()

    /// action konfirmasi
    const KonfirmasiData = async (e) => {
        swal({
            title: `Yakin menyimpan data ${nomesin}?`,
            text: "Pastikan data yang anda hapus sudah sesuai!",
            icon: "warning",
            buttons: true,
            dangerMode: true
        }).then((willDelete) => {
            if (willDelete) {
                mesinPost(e)
                // swal("Poof! Your imaginary file has been deleted!", {
                //     icon: "success",
                // });
            }
        });
    }

    /// post to api
    const mesinPost = async (e) => {
        /// event handler
        e.preventDefault();
        /// initialize json value
        const datamesin = {
            nomesin: nomesin,
            keterangan: keterangan,
            idsite: idSite
        };
        /// sending data json to api
        await axios
            .post("mesin", datamesin, {
                headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
            })
            .then((response) => {
                setValidation("");
                swal(`${response.data.message}`, {
                    icon: "success",
                });
                history("/datamesin");
            })
            .catch((error) => {
                swal(`${error.response.data}`, {
                    icon: "error",
                });
            });
    };

    /// getting data site from api for dropdown site
    const loadSite = () => {
        return axios.get("site", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            const respon = response.data.data
            return respon
        }).catch((error) => {
            swal(`${error.response.data}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    return (
        <>
            {/* /// navigation bar */}
            <NavbarComponent />
            <div className="md:container lg:mx-auto  mt-3">
                {/* /// name page */}
                <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                    Tambah Mesin
                </h1>
                {/* /// form design */}
                <form className='w-full'>
                    {/* /// row 1 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Mesin</label>
                            <div className='relative'>
                                {/* <AsyncSelect className='block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight focus:outline-none focus:bg-white focus:border-gray-500' */}
                                <AsyncSelect
                                    cacheOptions
                                    defaultOptions
                                    getOptionLabel={e => e.nama}
                                    getOptionValue={e => e.idsite}
                                    loadOptions={loadSite}
                                    placeholder="Pilih Site..."
                                    onChange={(value) => {
                                        setIdSite(value.idsite)
                                    }}
                                />
                            </div>
                        </div>
                    </div>
                    {/* /// row 2 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input nomor mesin */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Nomor Mesin</label>
                            <input
                                type="text"
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Nomor Mesin'
                                values={nomesin}
                                required
                                onChange={(e) => setNomesin(e.target.value)} />
                        </div>
                    </div>
                    {/* /// row 3 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input keterangan */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Keterangan</label>
                            <input
                                type="text"
                                className='appearance-none block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Keterangan'
                                required
                                values={keterangan}
                                onChange={(e) => setKeterangan(e.target.value)} />
                        </div>
                    </div>
                    {/* /// warning dialog */}
                    {validation.message && (
                        <div className="px-4 py-3 leading-normal text-red-50 bg-danger rounded-lg" role={alert}>{validation.message}</div>
                    )}
                    {/* /// button simpan */}
                    <button type='button' onClick={(e) => KonfirmasiData(e)} data-modal-toggle="popup-modal" className='mt-8 w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-600'>Simpan</button>
                </form>
            </div>
        </>
    );
}

export default AddMesin;
